import type z from "zod";

import { EVENTS } from "../../../config/EventCalendarConfig.js";
import { attackLootHandler } from "../../../controllers/base/save/handlers/attackLootHandler.js";
import { Event, type EventBaseState } from "../../../database/models/event.model.js";
import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { EVENT_BY_BASE, EVENT_BASES, EVENT_BASES_MAP, EVENT_COPY_BASES } from "../../../game-data/tribes/events/index.js";
import { BaseSaveSchema } from "../../../schemas/BaseSaveSchema.js";
import { postgres } from "../../../server.js";
import type { BuildingHealthData } from "../../../types/BuildingData.js";
import type { SaveData } from "../../../types/EntityData.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getActiveEvents, type ScheduledEvent } from "../calendar/eventCalendar.js";

type BaseSaveData = z.infer<typeof BaseSaveSchema>;

/** How long a damaged event base stays damaged - 24 hours */
const BASE_REPAIR_TIME = 86400;

/**
 * Checks whether a base is one of the bases attacked during an event.
 *
 * @param {string} baseid - The base ID
 * @returns {boolean} Whether it is an event base
 */
export const isEventBase = (baseid: string) => EVENT_BASES_MAP.has(baseid);

/**
 * Lists the bases of an event in the form the client reads them, in attack order.
 * Creature Carnage works out the player's progress from which bases are destroyed.
 *
 * @param {GameEvent} event - The event
 * @param {Event | null} progress - The player's row for this run of the event
 * @returns {{ id: number; level: number; destroyed: boolean }[]} The bases
 */
export const getEventBases = (event: GameEvent, progress: Event | null) => {
  const bases = EVENT_BASES[event] ?? [];

  return bases.map((base) => {
    const state = progress?.bases[String(base.baseid)];
    const isDestroyed = Boolean(state?.destroyed);

    return { id: Number(base.baseid), level: base.level, destroyed: isDestroyed };
  });
};

/**
 * Builds the key of the player's row for the active run of the event a base belongs to.
 *
 * @param {number} userid - The player
 * @param {string} baseid - The event base ID
 * @returns The key, or null when the base's event is not active
 */
const getBaseEventKey = (userid: number, baseid: string) => {
  const event = EVENT_BY_BASE.get(baseid);
  const scheduled = getActiveEvents().find((active) => active.event === event);

  if (!scheduled) return null;

  return { userid, event: scheduled.event, start_time: scheduled.start };
};

/**
 * Gets the damage a player's earlier attacks have left on an event base.
 * A base returns to full health when it is not destroyed within 24 hours of the first attack.
 *
 * @param {EventBaseState | undefined} state - The stored state of the base
 * @returns {EventBaseState | null} The state, or null when the base is at full health
 */
const getBaseDamage = (state: EventBaseState | undefined) => {
  if (!state || state.destroyed) return null;

  const isRepaired = getCurrentDateTime() - state.firstAttackedAt >= BASE_REPAIR_TIME;

  if (isRepaired) return null;

  return state;
};

/**
 * Gets the data an event base is built from.
 * The copy base takes its buildings from the stored copy of the player's own base.
 *
 * @param {SaveData} base - The static definition of the base
 * @param {GameEvent} event - The event the base belongs to
 * @param {Event | null} progress - The player's row for this run of the event
 * @returns {SaveData} The base's data
 */
const getBaseData = (base: SaveData, event: GameEvent, progress: Event | null) => {
  const isCopyBase = base === EVENT_COPY_BASES[event];

  if (!isCopyBase) return base;

  if (!progress || !progress.base_copy) throw new Error(`Event base has not been copied: ${base.baseid}`);

  return { ...base, ...progress.base_copy };
};

/**
 * Copies the player's own base for the last attack of an event, once per run of the event.
 * The copy is only made once the player's score has earned it.
 *
 * @param {User} user - The player, with their save loaded
 * @param {ScheduledEvent} scheduled - The scheduled event
 * @returns {Promise<number | undefined>} The base ID of the copy, or undefined when there is none
 */
export const copyEventBase = async (user: User, scheduled: ScheduledEvent) => {
  const { event, start } = scheduled;
  const { copyBaseScore } = EVENTS[event];

  const copyBase = EVENT_COPY_BASES[event];

  if (!copyBase || copyBaseScore === undefined) return undefined;

  const progress = await postgres.em.findOne(Event, { userid: user.userid, event, start_time: start });
  if (!progress) return undefined;

  const hasEarnedCopy = progress.score >= copyBaseScore;
  if (!hasEarnedCopy) return undefined;

  const baseid = Number(copyBase.baseid);

  if (progress.base_copy) return baseid;

  const userSave = user.save!;

  const baseCopy = { buildingdata: userSave.buildingdata ?? {}, level: userSave.level };

  progress.base_copy = baseCopy;
  await postgres.em.persist(progress).flush();

  return baseid;
};

/**
 * Generates a synthetic Save for an event base the player is about to attack.
 *
 * Damage from the player's earlier attacks in this run of the event is carried over.
 * A base stored as destroyed is served undamaged: the client only asks for one again
 * when its points were never counted.
 *
 * @param {User} user - The attacking user
 * @param {string} baseid - The event base ID
 * @returns {Promise<Save>} A synthetic Save representing the base
 */
export const loadEventBase = async (user: User, baseid: string): Promise<Save> => {
  const base = EVENT_BASES_MAP.get(baseid);

  if (!base) throw new Error(`No event base found for baseid: ${baseid}`);

  const key = getBaseEventKey(user.userid, baseid);

  if (!key) throw new Error(`No active event for event base: ${baseid}`);

  const progress = await postgres.em.findOne(Event, key);
  const baseData = getBaseData(base, key.event, progress);

  const save = Object.assign(new Save(), {
    ...baseData,
    attackid: Math.floor(Math.random() * 99999) + 1,
    buildinghealthdata: {},
    monsters: baseData.monsters ?? {},
  });

  if (!progress) return save;

  const damage = getBaseDamage(progress.bases[baseid]);
  if (!damage) return save;

  save.buildinghealthdata = damage.healthData;

  if (damage.monsters) save.monsters = damage.monsters;

  return save;
};

/**
 * Works out whether an attack has destroyed an event base: its Town Hall is down, which is
 * when the client itself treats the attack as won.
 *
 * @param {SaveData["buildingdata"]} buildingdata - The base's buildings
 * @param {BuildingHealthData} buildinghealthdata - The health of each damaged building, 0 when destroyed
 * @returns {number} 1 when destroyed, otherwise 0
 */
const getBaseDestroyed = (buildingdata: SaveData["buildingdata"], buildinghealthdata: BuildingHealthData) => {
  if (!buildingdata) return 0;

  const townHall = extractTownHall(buildingdata);
  if (!townHall) return 0;

  const isTownHallDown = buildinghealthdata[String(townHall.id)] === 0;

  return isTownHallDown ? 1 : 0;
};

/**
 * Handles a save posted during an attack on an event base.
 * Stores the attacker's remaining monsters, champion and loot, and the base's building
 * health, monsters and destroyed state against the player's row for this run of the event.
 *
 * @param {User} user - The attacking user
 * @param {BaseSaveData} saveData - Parsed save payload from the client
 * @returns {Promise<Save>} Synthetic Save reflecting the updated event base state
 */
export const saveEventBaseAttack = async (user: User, saveData: BaseSaveData): Promise<Save> => {
  const { baseid } = saveData;
  const userSave = user.save!;
  
  const base = EVENT_BASES_MAP.get(baseid);

  if (!base) throw new Error(`No event base found for baseid: ${baseid}`);

  if (saveData.attackcreatures) userSave.monsters = saveData.attackcreatures;
  if (saveData.attackerchampion) userSave.champion = saveData.attackerchampion;
  if (saveData.attackloot) attackLootHandler(saveData.attackloot, userSave);

  postgres.em.persist(userSave);

  const key = getBaseEventKey(user.userid, baseid);

  if (!key) throw new Error(`No active event for event base: ${baseid}`);

  const existing = await postgres.em.findOne(Event, key);
  const baseData = getBaseData(base, key.event, existing);
  const progress = existing ?? postgres.em.create(Event, key);

  const previous = getBaseDamage(progress.bases[baseid]);
  const previousHealth = previous ? previous.healthData : {};
  const firstAttackedAt = previous ? previous.firstAttackedAt : getCurrentDateTime();

  const healthData = saveData.buildinghealthdata ?? previousHealth;

  const destroyed = getBaseDestroyed(baseData.buildingdata, healthData);

  const state: EventBaseState = {
    healthData,
    monsters: saveData.monsters,
    destroyed,
    firstAttackedAt,
  };

  progress.bases = { ...progress.bases, [baseid]: state };

  postgres.em.persist(progress);
  await postgres.em.flush();

  return Object.assign(new Save(), {
    ...baseData,
    buildinghealthdata: state.healthData,
    monsters: state.monsters ?? baseData.monsters ?? {},
    destroyed: state.destroyed,
  });
};
