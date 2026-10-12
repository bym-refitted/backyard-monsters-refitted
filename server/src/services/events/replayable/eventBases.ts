import type z from "zod";

import { Event, type EventBaseState } from "../../../database/models/event.model.js";
import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { EVENT_BY_BASE, EVENT_BASES, EVENT_BASES_MAP } from "../../../game-data/tribes/events/index.js";
import { BaseSaveSchema } from "../../../schemas/BaseSaveSchema.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getActiveEvents } from "../calendar/eventCalendar.js";

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
 *
 * @param {GameEvent} event - The event
 * @returns {{ id: number; level: number }[]} The bases
 */
export const getEventBases = (event: GameEvent) => {
  const bases = EVENT_BASES[event] ?? [];

  return bases.map((base) => ({ id: Number(base.baseid), level: base.level }));
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

  const save = Object.assign(new Save(), {
    ...base,
    attackid: Math.floor(Math.random() * 99999) + 1,
    buildinghealthdata: {},
    monsters: base.monsters ?? {},
  });

  const progress = await postgres.em.findOne(Event, key);
  if (!progress) return save;

  const damage = getBaseDamage(progress.bases[baseid]);
  if (!damage) return save;

  save.buildinghealthdata = damage.healthData;

  if (damage.monsters) save.monsters = damage.monsters;

  return save;
};

/**
 * Handles a save posted during an attack on an event base.
 * Stores the attacker's remaining monsters and champion, and the base's building
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

  postgres.em.persist(userSave);

  const key = getBaseEventKey(user.userid, baseid);

  if (!key) throw new Error(`No active event for event base: ${baseid}`);

  const existing = await postgres.em.findOne(Event, key);
  const event = existing ?? postgres.em.create(Event, key);

  const previous = getBaseDamage(event.bases[baseid]);
  const previousHealth = previous ? previous.healthData : {};
  const firstAttackedAt = previous ? previous.firstAttackedAt : getCurrentDateTime();

  const state: EventBaseState = {
    healthData: saveData.buildinghealthdata ?? previousHealth,
    monsters: saveData.monsters,
    destroyed: saveData.destroyed ?? 0,
    firstAttackedAt,
  };

  event.bases = { ...event.bases, [baseid]: state };

  postgres.em.persist(event);
  await postgres.em.flush();

  return Object.assign(new Save(), {
    ...base,
    buildinghealthdata: state.healthData,
    monsters: state.monsters ?? base.monsters ?? {},
    destroyed: state.destroyed,
  });
};
