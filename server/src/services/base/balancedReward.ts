import { KorathReward, Reward } from "../../enums/Rewards.js";
import { Save } from "../../models/save.model.js";
import { extractTownHall, type TownHall } from "../../utils/extractTownHall.js";

const INITIAL_KRALLEN_DATA = { countdown: 443189, wins: 5, tier: 5, loot: 750000000000 };

/**
 * Adds rewards to the user's save data based on their Town Hall level.
 *
 * Town Hall Level 6: Korath
 * Town Hall Level 7: Krallen
 * Town Hall Level 8: Diamond Spurtz
 *
 * @param {Save} userSave - The user's save data.
 * @returns {Promise<void>} A promise that resolves when the balanced rewards are added.
 */
export const balancedReward = async (userSave: Save) => {
  let rewards = userSave.rewards!;
  const { KORATH, KRALLEN, REZGHUL, DIAMOND_SPURTZ } = Reward;

  // Early return if all rewards are already assigned
  if (rewards[KORATH] && rewards[KRALLEN] && rewards[DIAMOND_SPURTZ]) return;

  const townHall: TownHall | null = extractTownHall(userSave.buildingdata ?? {});
  if (!townHall || !townHall.l) return;

  let townHallLevel = townHall.l;

  // Town Hall Level 6
  if (townHallLevel >= 6 && !rewards[KRALLEN]) {
    rewards[KRALLEN] = { id: KRALLEN, value: 1 };
    addKrallenData(userSave);
  }

  // Re-initialize KOTH round data if it was wiped (e.g. by the NullifyEmptyKrallenData migration)
  // but the reward was already granted. Without this the client receives krallen:null and the
  // KOTHHandler can't display the HUD or champion cage.
  if (townHallLevel >= 6 && rewards[KRALLEN] && userSave.krallen == null) {
    userSave.krallen = INITIAL_KRALLEN_DATA;
  }

  // Town Hall Level 7
  if (townHallLevel >= 7 && !rewards[KORATH]) {
    rewards[KORATH] = { id: KORATH, value: KorathReward.FISTS_OF_DOOM };
  }

  // Town Hall Level 8
  if (townHallLevel >= 8 && !rewards[REZGHUL]) {
    rewards[REZGHUL] = { id: REZGHUL };
  }

  // Town Hall Level 9
  if (townHallLevel >= 9 && !rewards[DIAMOND_SPURTZ]) {
    rewards[DIAMOND_SPURTZ] = { id: DIAMOND_SPURTZ };
  }
};

/**
 * Adds Krallen data to the user's save, including champion data and reward metadata.
 *
 * @param {Save} userSave - The user's save data to update.
 */
const addKrallenData = (userSave: Save) => {
  const championData = userSave.champion;

  const hasKrallenChampion = championData.some((champion) => champion.t === 5);

  if (!hasKrallenChampion) {
    championData.push({
      fb: 0,
      l: 5,
      pl: 2,
      status: 0,
      t: 5,
      ft: 1730563770,
      fd: 0,
      hp: 62000,
    });

    userSave.krallen = INITIAL_KRALLEN_DATA;
  }
};
