import { KORATH_GOALS } from "../../../config/MonsterMadnessConfig.js";
import { Save } from "../../../database/models/save.model.js";
import { Reward } from "../../../enums/Rewards.js";
import { postgres } from "../../../server.js";
import type { RewardsData } from "../../../types/RewardData.js";

type Rewards = RewardsData | null | undefined;

/**
 * Gets the Korath level a player holds: the value of their Korath reward.
 *
 * @param {Rewards} rewards - The player's rewards
 * @returns {number} 1 for Korath, 2 for Breath of Fire, 3 for Fists of Doom, or 0 for none
 */
const getHeldKorathLevel = (rewards: Rewards) => rewards?.[Reward.KORATH]?.value ?? 0;

/**
 * Gives a player the Korath level their Monster Madness score has earned. A level is never lowered, so a player who
 * already holds an equal or higher one keeps it.
 *
 * @param {Save} save - The player's main yard
 * @param {number} score - Their score in the current run of Monster Madness
 */
export const grantKorathReward = (save: Save, score: number) => {
  const heldLevel = getHeldKorathLevel(save.rewards);
  const earnedLevel = KORATH_GOALS.filter((goal) => score >= goal).length;

  if (earnedLevel <= heldLevel) return;

  save.rewards = { ...save.rewards, [Reward.KORATH]: { id: Reward.KORATH, value: earnedLevel } };
};

/**
 * Gives a player any Korath level their Monster Madness score has earned, and returns the level they hold for the
 * client to apply. Run on every score read, so a level missed for any reason is granted on the player's next visit
 * home; takeovers grant it straight away.
 *
 * @param {Save} save - The player's main yard
 * @param {number} score - Their score in the current run of Monster Madness
 * @returns {Promise<number>} The level they hold, or 0 for none
 */
export const settleKorathReward = async (save: Save, score: number) => {
  grantKorathReward(save, score);
  await postgres.em.flush();

  return getHeldKorathLevel(save.rewards);
};
