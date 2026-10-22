import { Save } from "../../../database/models/save.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { settleSpurtzReward } from "./spurtzRewards.js";

/**
 * Gets the reward fields to send with a player's score in an event, granting any reward the
 * score has earned first. Only Brukkarg War has server-granted rewards: its Spurtz Cannon
 * reward goes out as `spurtzreward`.
 *
 * @param {Save} save - The player's main yard
 * @param {GameEvent} event - The event the score belongs to
 * @param {number | undefined} score - The player's score, or undefined when it was not accepted
 * @returns {Promise<Record<string, unknown>>} The fields to add to the response
 */
export const getEventRewardFields = async (save: Save, event: GameEvent, score: number | undefined) => {
  const isBrukkargWar = event === GameEvent.BRUKKARG_WAR;

  if (!isBrukkargWar || score === undefined) return {};

  const spurtzreward = await settleSpurtzReward(save, score);

  return { spurtzreward };
};
