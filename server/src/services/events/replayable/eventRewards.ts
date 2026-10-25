import { Save } from "../../../database/models/save.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { settleKorathReward } from "../monsterMadness/korathRewards.js";
import { settleSpurtzReward } from "./spurtzRewards.js";

/**
 * Gets the reward fields to send with a player's score in an event, granting any reward the
 * score has earned first. Brukkarg War's Spurtz Cannon reward goes out as `spurtzreward`, and
 * Monster Madness's Korath level as `korathreward`.
 *
 * @param {Save} save - The player's main yard
 * @param {GameEvent} event - The event the score belongs to
 * @param {number | undefined} score - The player's score, or undefined when it was not accepted
 * @returns {Promise<Record<string, unknown>>} The fields to add to the response
 */
export const getEventRewardFields = async (save: Save, event: GameEvent, score: number | undefined) => {
  if (score === undefined) return {};

  switch (event) {
    case GameEvent.BRUKKARG_WAR:
      return { spurtzreward: await settleSpurtzReward(save, score) };

    case GameEvent.MONSTER_MADNESS:
      return { korathreward: await settleKorathReward(save, score) };

    default:
      return {};
  }
};
