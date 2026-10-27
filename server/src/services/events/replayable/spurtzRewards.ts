import {
  BRUKKARG_SCORE_PER_YARD,
  SPURTZ_CANNON_LIMIT,
  SPURTZ_CANNON_TYPES,
  SPURTZ_REWARD_YARDS,
  SPURTZ_REWARDS,
} from "../../../config/BrukkargConfig.js";
import { Save } from "../../../database/models/save.model.js";
import { postgres } from "../../../server.js";
import type { BuildingDataMap } from "../../../types/BuildingData.js";
import type { RewardsData } from "../../../types/RewardData.js";

type Rewards = RewardsData | null | undefined;

type Buildings = BuildingDataMap | null | undefined;

/**
 * Gets the rank of the Spurtz Cannon reward a player holds.
 *
 * @param {Rewards} rewards - The player's rewards
 * @returns {number} The index in SPURTZ_REWARDS of the highest one held, or -1 for none
 */
const getHeldRank = (rewards: Rewards) => {
  if (!rewards) return -1;

  return SPURTZ_REWARDS.findLastIndex((reward) => Object.hasOwn(rewards, reward));
};

/**
 * Copies a player's rewards without any Spurtz Cannon reward.
 *
 * @param {Rewards} rewards - The player's rewards
 * @returns {RewardsData} The other rewards
 */
const withoutSpurtzRewards = (rewards: Rewards): RewardsData => {
  const entries = Object.entries(rewards ?? {});
  const otherEntries = entries.filter(([id]) => !SPURTZ_REWARDS.some((reward) => reward === id));

  return Object.fromEntries(otherEntries);
};

/**
 * Gets the Spurtz Cannon reward a player holds.
 *
 * @param {Rewards} rewards - The player's rewards
 * @returns {Reward | null} The reward, or null for none
 */
const getSpurtzReward = (rewards: Rewards) => {
  const rank = getHeldRank(rewards);

  return SPURTZ_REWARDS[rank] ?? null;
};

/**
 * Gives a player the Spurtz Cannon reward their Brukkarg War score has earned, replacing
 * the one they hold. A player who already holds an equal or higher one keeps it.
 *
 * @param {Save} save - The player's main yard
 * @param {number} score - Their score in the current run of Brukkarg War
 */
const grantSpurtzReward = (save: Save, score: number) => {
  const yardsDestroyed = Math.floor(score / BRUKKARG_SCORE_PER_YARD);

  const heldRank = getHeldRank(save.rewards);
  const earnedRank = SPURTZ_REWARD_YARDS.filter((yards) => yardsDestroyed >= yards).length - 1;

  if (earnedRank <= heldRank) return;

  const reward = SPURTZ_REWARDS[earnedRank];
  const without = withoutSpurtzRewards(save.rewards);

  save.rewards = { ...without, [reward]: { id: reward } };
};

/**
 * Gives a player any Spurtz Cannon reward their Brukkarg War score has earned, and returns the
 * one they hold for the client to apply. Run on every score read as well as every score update,
 * so a reward missed for any reason is granted on the player's next visit home.
 *
 * @param {Save} save - The player's main yard
 * @param {number} score - Their score in the current run of Brukkarg War
 * @returns {Promise<Reward | null>} The reward they hold, or null for none
 */
export const settleSpurtzReward = async (save: Save, score: number) => {
  grantSpurtzReward(save, score);
  await postgres.em.flush();

  return getSpurtzReward(save.rewards);
};

/**
 * Counts the Spurtz Cannons and Black Diamond Spurtz Cannons in a yard.
 *
 * @param {Buildings} buildings - The yard's buildings
 * @returns {number} The number of cannons
 */
const countCannons = (buildings: Buildings) => {
  const allBuildings = Object.values(buildings ?? {});
  const cannons = allBuildings.filter((building) => building && SPURTZ_CANNON_TYPES.includes(building.t));

  return cannons.length;
};

/**
 * Whether saving incoming over stored would add Spurtz Cannons beyond what the player's
 * reward allows. A yard that already has more keeps them; it just can't add another.
 *
 * @param {Buildings} stored - The yard's buildings in the database
 * @param {Buildings} incoming - The buildings sent by the client, absent when the save leaves them alone
 * @param {Rewards} rewards - The player's rewards in the database
 * @returns {boolean} True when the save has more cannons than both the stored yard and the reward allow
 */
export const addsSpurtzCannons = (stored: Buildings, incoming: Buildings, rewards: Rewards) => {
  if (!incoming) return false;

  const rank = getHeldRank(rewards);
  const limit = SPURTZ_CANNON_LIMIT[rank] ?? 0;

  const allowed = Math.max(countCannons(stored), limit);

  return countCannons(incoming) > allowed;
};
