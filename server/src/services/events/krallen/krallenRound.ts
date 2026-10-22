import {
  KRALLEN_AWARD_THRESHOLD,
  KRALLEN_KEPT_UPGRADE_THRESHOLD,
  KRALLEN_MAP_ROOMS,
  KRALLEN_MIN_TOWN_HALL,
  KRALLEN_ROUND_DAYS,
  KRALLEN_ROUND_END_WEEKDAY,
  KRALLEN_START_TIME,
  KRALLEN_TIME_ZONE,
  KRALLEN_UPGRADE_THRESHOLD,
  KRALLEN_WINS_TO_KEEP,
} from "../../../config/KrallenConfig.js";
import { Save } from "../../../database/models/save.model.js";
import {
  KrallenStoredSchema,
  type KrallenData,
  type KrallenStoredData,
} from "../../../schemas/KrallenSchema.js";
import { dateToEpoch, epochToDate } from "../../../utils/epochDate.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

type KrallenStreak = Pick<KrallenStoredData, "wins">;

const DAYS_PER_WEEK = 7;

const SECONDS_PER_DAY = 86400;

const TIER_NONE = 0;

const TIER_KRALLEN = 1;

const TIER_UPGRADED = 2;

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
 * Checks whether a player is on a Map Room that takes part in Hunt for Krallen.
 *
 * @param {Save} save - The player's main yard
 * @returns {boolean} Whether the player's Map Room takes part
 */
export const isInKrallenMapRoom = (save: Save) => KRALLEN_MAP_ROOMS.includes(save.mapversion);

/**
 * Checks whether a player's main yard can take part in Hunt for Krallen. Nobody can before
 * the Hunt opens, so no loot counts during its launch countdown.
 *
 * @param {Save} save - The player's main yard
 * @param {number} now - The current time, in seconds
 * @returns {boolean} Whether the player qualifies
 */
export const isKrallenEligible = (save: Save, now: number = getCurrentDateTime()) => {
  const hasStarted = now >= KRALLEN_START_TIME;

  if (!hasStarted || !isInKrallenMapRoom(save)) return false;

  const townHall = extractTownHall(save.buildingdata ?? {});

  if (!townHall) return false;

  return townHall.l >= KRALLEN_MIN_TOWN_HALL;
};

/**
 * Works out a player's tier and wins at the end of a round, from the loot they gathered in it.
 *
 * Winning adds to the streak and awards the Krallen, or its upgraded power above the upgrade
 * target. Missing the target ends the streak and takes the Krallen away, unless the player
 * has already won enough rounds in a row to keep it, in which case it drops to its base power.
 * Once kept, the client shows the upgrade target as the loot above the award target
 * (KOTHHandler.initialize), so that is the target used.
 *
 * @param {KrallenStreak} round - The player's progress going into the round's end
 * @param {number} loot - The loot gathered in the round
 * @returns {{ tier: number; wins: number }} The tier and wins after the round
 */
const settleRound = (round: KrallenStreak, loot: number) => {
  const { wins } = round;

  const ownsForGood = wins >= KRALLEN_WINS_TO_KEEP;
  const hasWon = loot >= KRALLEN_AWARD_THRESHOLD;

  if (hasWon) {
    const upgradeTarget = ownsForGood ? KRALLEN_KEPT_UPGRADE_THRESHOLD : KRALLEN_UPGRADE_THRESHOLD;
    const isUpgraded = loot >= upgradeTarget;

    const wonRound = { wins: wins + 1, tier: isUpgraded ? TIER_UPGRADED : TIER_KRALLEN };

    return wonRound;
  }

  if (ownsForGood) return { wins, tier: TIER_KRALLEN };

  return { wins: 0, tier: TIER_NONE };
};

/**
 * Gets a player's stored Hunt for Krallen data for the current round.
 *
 * When the saved round has ended, it is settled and the current round starts with no loot.
 * Rounds missed since then count as rounds with no loot. A player with no saved round (who
 * hasn't looted yet) has nothing to settle. The latest attack is kept, so an attack still
 * running when a round ends only adds its remaining loot to the new round.
 *
 * The ended round's loot and tier are kept until the next full load tells the client, so
 * it can show the end-of-round message even if an attack saved the new round first.
 *
 * @param {Save} save - The player's main yard
 * @param {number} now - The current time, in seconds
 * @returns {KrallenStoredData} The data for the current round
 */
export const getCurrentRound = (save: Save, now: number = getCurrentDateTime()): KrallenStoredData => {
  const savedRound = KrallenStoredSchema.parse(save.krallen ?? {});
  const roundEnd = getRoundEnd(now);

  const isRoundOver = savedRound.roundEnd < roundEnd;
  if (!isRoundOver) return savedRound;

  const newRound = { ...savedRound, loot: 0, lastShownTier: 0, roundEnd };

  const hasSavedRound = savedRound.roundEnd > 0;
  if (!hasSavedRound) return newRound;

  const settledRound = settleRound(savedRound, savedRound.loot);

  const nextRoundEnd = savedRound.roundEnd + KRALLEN_ROUND_DAYS * SECONDS_PER_DAY;
  const hasMissedRounds = nextRoundEnd < roundEnd;

  const settled = hasMissedRounds ? settleRound(settledRound, 0) : settledRound;

  return { ...newRound, ...settled, endedRoundLoot: savedRound.loot, endedRoundTier: savedRound.tier };
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
  if (!isKrallenEligible(save, now)) return null;

  const { tier, wins, loot, lastShownTier, roundEnd } = getCurrentRound(save, now);
  const countdown = roundEnd - now;

  return { tier, wins, loot, countdown, lastShownTier };
};
