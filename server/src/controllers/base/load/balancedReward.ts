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
  let townHall: any = null;
  for(const key in buildingData) {
    const building = buildingData[key];
    if(!building) {
      continue;
    }
    if (building.t !== 14) continue;

    townHall = building;
    break;
  }
  if (townHall) return townHall;

  throw new Error("Cannot find townhall in payload")
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
  // TODO: For some reason, the townhall in some rare cases is not the first building ("0") in the buildingdata object.
  // Instead it can be identifed by the "t" property in the buildingdata object being 14.
  const townHall = parseTownhallFromBuildingData(userSave.buildingdata);

  if (townHall && townHall.l >= 6) {
    userSave.rewards = {
      [Reward.KORATH]: { id: Reward.KORATH, value: KorathReward.FISTS_OF_DOOM },
      ...userSave.rewards,
    };
  }

  if (townHall && townHall.l >= 7) {
    let champ = userSave.champion;
    let championData = [];
    if(typeof champ === "string") {
      championData = JSON.parse(userSave.champion || "[]");
    }
    else {
      championData = champ;
    }

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

  if (townHall && townHall.l >= 8) {
    userSave.rewards = {
      [Reward.DIAMOND_SPURTZ]: { id: Reward.DIAMOND_SPURTZ },
      ...userSave.rewards,
    };
  }

  ORMContext.em.persistAndFlush(userSave);
};
