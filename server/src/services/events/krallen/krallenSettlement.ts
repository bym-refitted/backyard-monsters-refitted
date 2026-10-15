import { KRALLEN_CHAMPION_TYPE, KRALLEN_MAX_LEVEL } from "../../../config/KrallenConfig.js";
import { Save } from "../../../database/models/save.model.js";
import { Reward } from "../../../enums/Rewards.js";
import type { KrallenStoredData } from "../../../schemas/KrallenSchema.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getCurrentRound } from "./krallenRound.js";

const LAST_ROUND_LOOT_STAT = "lastKOTHScore";

const LAST_ROUND_TIER_STAT = "lastKOTHTier";

const INT_MAX = 2_147_483_647;

/**
 * Takes the Krallen away from a player: both Krallen rewards and the champion itself,
 * whether it is in the Champion Cage or frozen in the Champion Chamber.
 *
 * @param {Save} save - The player's main yard
 */
const removeKrallen = (save: Save) => {
  const rewards = save.rewards ?? {};

  const hasReward = Object.hasOwn(rewards, Reward.KRALLEN) || Object.hasOwn(rewards, Reward.KRALLEN_BUFF);
  const hasChampion = save.champion.some((champion) => champion.t === KRALLEN_CHAMPION_TYPE);

  if (hasReward) {
    const { [Reward.KRALLEN]: _, [Reward.KRALLEN_BUFF]: __, ...otherRewards } = rewards;

    save.rewards = otherRewards;
  }

  if (hasChampion) {
    save.champion = save.champion.filter((champion) => champion.t !== KRALLEN_CHAMPION_TYPE);
  }
};

/**
 * Sets the Krallen's two rewards from the player's progress: its power from the tier and its
 * level from the wins, capped as KrallenBuffReward caps it.
 *
 * @param {Save} save - The player's main yard
 * @param {KrallenStoredData} round - The player's settled progress
 */
const updateKrallenRewards = (save: Save, round: KrallenStoredData) => {
  const level = Math.min(round.wins, KRALLEN_MAX_LEVEL);

  save.rewards = {
    ...save.rewards,
    [Reward.KRALLEN]: { id: Reward.KRALLEN, value: round.tier },
    [Reward.KRALLEN_BUFF]: { id: Reward.KRALLEN_BUFF, value: level },
  };
};

/**
 * Leaves the client what it needs to show the end-of-round message (KOTHHandler.checkEventReset):
 * the ended round's loot and the tier going into it, read through GLOBAL.StatGet. The client
 * shows the message when the current loot is lower than that loot, so they are only set on the
 * load that tells it about a round, and removed on every other load so the message shows once.
 * StatGet reads an int, so the loot is capped at the int maximum.
 *
 * @param {Save} save - The player's main yard
 * @param {KrallenStoredData} round - The player's settled progress
 */
const setRoundEndStats = (save: Save, round: KrallenStoredData) => {
  const { [LAST_ROUND_LOOT_STAT]: _, [LAST_ROUND_TIER_STAT]: __, ...otherStats } = save.stats?.other ?? {};

  const hasEndedRound = round.endedRoundLoot > 0;

  if (hasEndedRound) {
    otherStats[LAST_ROUND_LOOT_STAT] = Math.min(round.endedRoundLoot, INT_MAX);
    otherStats[LAST_ROUND_TIER_STAT] = round.endedRoundTier;
  }

  save.stats = { ...save.stats, other: otherStats };
};

/**
 * Settles any Hunt for Krallen rounds that have ended since the player's last visit and
 * saves the result, whichever Map Room the player is in.
 *
 * The Krallen's rewards are then brought in line with the result: removed along with the
 * Krallen when the player is left without it, otherwise set to its tier and level. The client
 * does the same (KOTHHandler.updateRewards), but only while the contest is switched on for
 * the player, which it isn't once they have gone back to Map Room 1.
 *
 * @param {Save} save - The player's main yard
 * @param {number} now - The current time, in seconds
 */
export const settleKrallen = (save: Save, now = getCurrentDateTime()) => {
  if (!save.krallen) return;

  const round = getCurrentRound(save, now);

  setRoundEndStats(save, round);

  save.krallen = { ...round, endedRoundLoot: 0, endedRoundTier: 0 };

  const hasKrallen = round.tier > 0;

  if (!hasKrallen) {
    removeKrallen(save);
    return;
  }

  updateKrallenRewards(save, round);
};
