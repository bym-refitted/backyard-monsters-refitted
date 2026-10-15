import {
  KRALLEN_MIN_TOWN_HALL,
  KRALLEN_ROUND_END_WEEKDAY,
  KRALLEN_TIME_ZONE,
} from "../../../config/KrallenConfig.js";
import { Save } from "../../../database/models/save.model.js";
import { KrallenSchema, type KrallenData } from "../../../schemas/KrallenSchema.js";
import { dateToEpoch, epochToDate } from "../../../utils/epochDate.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

const DAYS_PER_WEEK = 7;

/**
 * Gets the time the current Hunt for Krallen round ends. Every player shares the same
 * weekly round, which ends at 00:00 on the configured weekday.
 *
 * @param {number} now - The current time, in seconds
 * @returns {number} The end of the current round, in seconds
 */
export const getRoundEnd = (now: number = getCurrentDateTime()) => {
  const today = epochToDate(now, KRALLEN_TIME_ZONE);

  const weekdaysAhead = (KRALLEN_ROUND_END_WEEKDAY - today.dayOfWeek + DAYS_PER_WEEK) % DAYS_PER_WEEK;
  const daysUntilEnd = weekdaysAhead === 0 ? DAYS_PER_WEEK : weekdaysAhead;

  const endDate = today.add({ days: daysUntilEnd });

  return dateToEpoch(endDate, KRALLEN_TIME_ZONE);
};

/**
 * Checks whether a player's main yard can take part in Hunt for Krallen.
 *
 * @param {Save} save - The player's main yard
 * @returns {boolean} Whether the player qualifies
 */
const isKrallenEligible = (save: Save) => {
  const townHall = extractTownHall(save.buildingdata ?? {});

  if (!townHall) return false;

  return townHall.l >= KRALLEN_MIN_TOWN_HALL;
};

/**
 * Gets a player's Hunt for Krallen progress for the client, with the time left in the
 * current round. A player who hasn't taken part yet starts with no progress.
 *
 * @param {Save} save - The player's main yard
 * @param {number} now - The current time, in seconds
 * @returns {KrallenData | null} The progress, or null when the player doesn't qualify
 */
export const getKrallenData = (save: Save, now: number = getCurrentDateTime()): KrallenData | null => {
  if (!isKrallenEligible(save)) return null;

  const stored = KrallenSchema.parse(save.krallen ?? {});
  const countdown = getRoundEnd(now) - now;

  return { ...stored, countdown };
};
