import { LockMode, UniqueConstraintViolationException } from "@mikro-orm/core";

import { EVENT_TIME_ZONE } from "../../../config/EventCalendarConfig.js";
import {
  HALLOWEEN_DAY,
  HALLOWEEN_DECORATIONS,
  HALLOWEEN_MONTH,
  HALLOWEEN_RUN_DAYS,
  HALLOWEEN_SHINY,
} from "../../../config/HalloweenConfig.js";
import { Event } from "../../../database/models/event.model.js";
import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { postgres } from "../../../server.js";
import { dateToEpoch, epochToDate } from "../../../utils/epochDate.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import type { StoredBuildingCounts, StoredBuildingKey, StoredBuildings } from "../../../types/StoredBuildings.js";
import { visibleCredits } from "../../user/shinyLock.js";

export interface HalloweenData {
  active: number;
  opened: number;
}

export interface HalloweenReward {
  granted: number;
  shiny: number;
  credits: number;
  decorations: StoredBuildingCounts;
}

const SECONDS_PER_DAY = 86400;

/**
 * Gets the start of the Halloween event that is under way: midnight on 30 October, running for HALLOWEEN_RUN_DAYS.
 *
 * @param {number} now - The current time
 * @returns {number | null} When this Halloween started, or null when it isn't Halloween
 */
export const getHalloweenStart = (now = getCurrentDateTime()) => {
  const today = epochToDate(now, EVENT_TIME_ZONE);
  
  const start = dateToEpoch(today.with({ month: HALLOWEEN_MONTH, day: HALLOWEEN_DAY }), EVENT_TIME_ZONE);
  const end = start + HALLOWEEN_RUN_DAYS * SECONDS_PER_DAY;

  return now >= start && now < end ? start : null;
};

/**
 * Tells the client whether to stand the Giant Pumpkin outside the player's yard: only on Halloween, and only until
 * they have opened this year's.
 *
 * @param {number} userid - The player
 * @returns {Promise<HalloweenData>} Whether it's Halloween, and whether they've opened the pumpkin
 */
export const getHalloweenData = async (userid: number): Promise<HalloweenData> => {
  const start = getHalloweenStart();

  if (!start) return { active: 0, opened: 0 };

  const opened = await postgres.em.count(Event, { userid, event: GameEvent.HALLOWEEN, start_time: start });

  return { active: 1, opened: Number(opened > 0) };
};

/**
 * Gets the building types a player already owns: placed in their main yard, or kept in storage.
 *
 * @param {Save} mainSave - The player's main yard, whose storage holds every stored building
 * @returns {Set<string>} The stored-building keys (`b<type>`) of the types they own
 */
const getOwnedBuildings = (mainSave: Save): Set<string> => {
  const owned = new Set<string>();

  for (const building of Object.values(mainSave.buildingdata ?? {})) owned.add(`b${building.t}`);

  for (const [key, count] of Object.entries(mainSave.researchdata ?? {})) {
    if (count && count > 0) owned.add(key);
  }

  return owned;
};

/**
 * Picks the decorations to give: those the player doesn't own anywhere yet. A player who was given them before keeps
 * what they have and gets only the ones they're missing.
 *
 * @param {Set<string>} owned - The stored-building keys of the types they own
 * @returns {StoredBuildingCounts} The decorations to give, by stored-building key
 */
const getMissingDecorations = (owned: Set<string>): StoredBuildingCounts => {
  const missing = Object.entries(HALLOWEEN_DECORATIONS).filter(([key]) => !owned.has(key));

  return Object.fromEntries(missing);
};

/**
 * Adds buildings to a player's stored buildings.
 *
 * @param {StoredBuildings | null | undefined} stored - Their stored buildings
 * @param {StoredBuildingCounts} added - The buildings to add, by type
 * @returns {StoredBuildings} Their stored buildings with the new ones
 */
const addStoredBuildings = (stored: StoredBuildings | null | undefined, added: StoredBuildingCounts): StoredBuildings => {
  const result: StoredBuildings = { ...stored };

  for (const key of Object.keys(added) as StoredBuildingKey[]) result[key] = (result[key] ?? 0) + (added[key] ?? 0);

  return result;
};

/**
 * The answer when nothing is given: outside Halloween, or once this year's pumpkin has been opened.
 *
 * @param {User} user - The player, with their main save populated
 * @returns {HalloweenReward} Nothing granted, and their Shiny balance
 */
const notGranted = (user: User): HalloweenReward => ({
  granted: 0,
  shiny: 0,
  credits: visibleCredits(user, user.save!.credits),
  decorations: {},
});

/**
 * Opens the player's Giant Pumpkin and gives them the Goodie Bag, once per Halloween. The year's `event` row is
 * written in the same transaction as the reward, so its unique key stops a repeat request from paying out twice.
 * Decorations the player already owns aren't given again.
 *
 * @param {User} user - The player, with their main save populated
 * @returns {Promise<HalloweenReward>} What was granted, and their Shiny balance
 */
export const openGiantPumpkin = async (user: User): Promise<HalloweenReward> => {
  const start = getHalloweenStart();

  if (!start) return notGranted(user);

  try {
    return await postgres.em.transactional(async (em) => {
      em.create(Event, { userid: user.userid, event: GameEvent.HALLOWEEN, start_time: start });
      await em.flush();

      const save = await em.findOneOrFail(
        Save,
        { basesaveid: user.save!.basesaveid },
        { lockMode: LockMode.PESSIMISTIC_WRITE },
      );

      const ownedBuildings = getOwnedBuildings(save);
      const decorations = getMissingDecorations(ownedBuildings);

      save.credits += HALLOWEEN_SHINY;
      save.researchdata = addStoredBuildings(save.researchdata, decorations);

      return { granted: 1, shiny: HALLOWEEN_SHINY, credits: visibleCredits(user, save.credits), decorations };
    });
  } catch (err) {
    if (!(err instanceof UniqueConstraintViolationException)) throw err;

    return notGranted(user);
  }
};
