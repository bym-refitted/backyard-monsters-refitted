import { isNullOrUndefined } from "util";
import { KorathReward, Reward } from "../../../enums/Rewards";
import { FieldData, Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";

/**
 * Returns the Town Hall building object contained in the given buildingData object.
 * Throws an error if the town hall cannot be found.
 * 
 * The object is identified by checking the `t` (type) variable on the child objects. 
 * If `t` is equal to 14, then it is considered a town hall.
 * 
 * @param buildingData the buildingData object to search
 * @returns the townHall object found
 * @throws Error when townHall Object cannot be found
 */
function parseTownhallFromBuildingData(buildingData: FieldData) {
  for (const key in buildingData) {
    const building = buildingData[key];

    if (building && building.t === 14) {
      return building;
    }
  }
  return null;
}

/**
 * Parses the champing data object from the player save. The champion object may not be a string but rather an object already.
 * This function only parses the rawChampionData when it is actually a string.
 */
function parseChampionData(rawChampionData:any) {
  // sometimes the champion variable is an object instead of a string,
  // so the JSON.parse call runs into an error that "[object Object]" is not valid JSON.
  if (typeof rawChampionData === "string") {
    return JSON.parse(rawChampionData || "[]");
  }
  return rawChampionData;
}

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
  let rewards = userSave.rewards;
  if (rewards) {
    let korath = rewards[Reward.KORATH];
    let krallen = rewards[Reward.KRALLEN];
    let diamondSpurtz = rewards[Reward.DIAMOND_SPURTZ];

    // return early if all rewards have been given already
    if (korath && krallen && diamondSpurtz) return;
  }

  const townHall = parseTownhallFromBuildingData(userSave.buildingdata);

  // If the save has no town hall, it could be an outpost.
  if (!townHall) return;

  let level = townHall.l;

  if (level >= 6) {
    userSave.rewards = {
      [Reward.KORATH]: { id: Reward.KORATH, value: KorathReward.FISTS_OF_DOOM },
      ...userSave.rewards,
    };
  }

  if (level >= 7) {
    let championData = parseChampionData(userSave.champion);

    if (Object.keys(userSave.krallen).length === 0) {
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

      championData.push(krallen);
      userSave.champion = JSON.stringify(championData);

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
    }
  }

  if (level >= 8) {
    userSave.rewards = {
      [Reward.DIAMOND_SPURTZ]: { id: Reward.DIAMOND_SPURTZ },
      ...userSave.rewards,
    };
  }

  ORMContext.em.persistAndFlush(userSave);
};
