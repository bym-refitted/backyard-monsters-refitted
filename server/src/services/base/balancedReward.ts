import { KorathReward, Reward } from "../../enums/Rewards.js";
import { Save } from "../../database/models/save.model.js";
import { extractTownHall, type TownHall } from "../../utils/extractTownHall.js";

/**
 * Adds rewards to the user's save data based on their Town Hall level.
 *
 * Town Hall Level 5: Vorg and Slimeattikus unblocked, so they can be researched
 * Town Hall Level 7: Korath
 * Town Hall Level 8: Rezghul
 *
 * @param {Save} userSave - The user's save data.
 * @returns {Promise<void>} A promise that resolves when the balanced rewards are added.
 */
export const balancedReward = async (userSave: Save) => {
  let rewards = userSave.rewards!;
  const { VORG, SLIMEATTIKUS, KORATH, REZGHUL } = Reward;

  // Early return if all rewards are already assigned
  if (rewards[VORG] && rewards[SLIMEATTIKUS] && rewards[KORATH] && rewards[REZGHUL]) return;

  const townHall: TownHall | null = extractTownHall(userSave.buildingdata ?? {});
  if (!townHall || !townHall.l) return;

  let townHallLevel = townHall.l;

  // Town Hall Level 5
  if (townHallLevel >= 5 && !rewards[VORG]) {
    rewards[VORG] = { id: VORG };
  }

  if (townHallLevel >= 5 && !rewards[SLIMEATTIKUS]) {
    rewards[SLIMEATTIKUS] = { id: SLIMEATTIKUS };
  }

  // Town Hall Level 7
  if (townHallLevel >= 7 && !rewards[KORATH]) {
    rewards[KORATH] = { id: KORATH, value: KorathReward.FISTS_OF_DOOM };
  }

  // Town Hall Level 8
  if (townHallLevel >= 8 && !rewards[REZGHUL]) {
    rewards[REZGHUL] = { id: REZGHUL };
  }
};
