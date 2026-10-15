import { KRALLEN_CHAMPION_TYPE } from "../../../config/KrallenConfig.js";
import { Save } from "../../../database/models/save.model.js";
import { Reward } from "../../../enums/Rewards.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getCurrentRound } from "./krallenRound.js";

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
 * Settles any Hunt for Krallen rounds that have ended since the player's last visit and
 * saves the result, whichever Map Room the player is in.
 *
 * A player left without the Krallen has it taken away here. The client does this itself
 * (KOTHHandler.updateRewards), but only while the contest is switched on for the player,
 * which it isn't once they have gone back to Map Room 1.
 *
 * @param {Save} save - The player's main yard
 * @param {number} now - The current time, in seconds
 */
export const settleKrallen = (save: Save, now = getCurrentDateTime()) => {
  if (!save.krallen) return;

  const round = getCurrentRound(save, now);

  save.krallen = round;

  const hasKrallen = round.tier > 0;

  if (!hasKrallen) removeKrallen(save);
};
