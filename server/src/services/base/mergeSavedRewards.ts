import { SPURTZ_REWARDS } from "../../config/BrukkargConfig.js";
import { Reward } from "../../enums/Rewards.js";
import type { RewardsData } from "../../types/RewardData.js";

type Rewards = RewardsData | null | undefined;

const SERVER_OWNED_REWARDS: string[] = [...SPURTZ_REWARDS, Reward.KORATH];

const isServerOwned = (id: string) => SERVER_OWNED_REWARDS.includes(id);

/**
 * Merges the rewards a client saved with the stored ones. The server owns some rewards, so the client's copies of
 * those are ignored and the stored ones kept: a client can't add, raise or remove them.
 *
 * @param {Rewards} stored - The rewards in the database
 * @param {RewardsData} saved - The rewards the client saved
 * @returns {RewardsData} The rewards to store
 */
export const mergeSavedRewards = (stored: Rewards, saved: RewardsData): RewardsData => {
  const clientOwned = Object.entries(saved).filter(([id]) => !isServerOwned(id));
  const serverOwned = Object.entries(stored ?? {}).filter(([id]) => isServerOwned(id));

  return Object.fromEntries([...clientOwned, ...serverOwned]);
};
