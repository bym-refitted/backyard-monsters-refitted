import { KorathReward, Reward } from "../../../enums/Rewards";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";

/**
 * Adds balanced rewards to the user's save data based on their town hall level.
 * 
 * Town Hall Level 6: Korath
 * Town Hall Level 7: Krallen
 * Town Hall Level 8: Diamond Spurtz
 *
 * @param {Save} userSave - The user's save data.
 * @returns {Promise<void>} A promise that resolves when the balanced rewards are added.
 */
export const balancedReward = async (userSave: Save) => {
  const townHall = userSave.buildingdata["0"];

  if (townHall && townHall.l >= 6) {
    userSave.rewards = {
      [Reward.KORATH]: { id: Reward.KORATH, value: KorathReward.FISTS_OF_DOOM },
      ...userSave.rewards,
    };
  }

  if (townHall && townHall.l >= 7) {
    userSave.krallen = {
      countdown: 443189,
      wins: 5,
      tier: 5,
      loot: 750000000000,
    };

    userSave.rewards = {
      [Reward.KRALLEN]: { id: Reward.KRALLEN, value: 1 },
      ...userSave.rewards,
    };

    let championData = JSON.parse(userSave.champion || "[]");

    const krallen = {
      fb: 0,
      l: 5,
      pl: 2,
      status: 0,
      log: "0",
      t: 5,
      ft: 1730563770,
      fd: 0,
      hp: 62000,
    };

    if (championData.length < 2) {
      championData.push(krallen);
      userSave.champion = JSON.stringify(championData);
    }
  }

  if (townHall && townHall.l >= 8) {
    userSave.rewards = {
      [Reward.DIAMOND_SPURTZ]: { id: Reward.DIAMOND_SPURTZ },
      ...userSave.rewards,
    };
  }

  ORMContext.em.persistAndFlush(userSave);
};
