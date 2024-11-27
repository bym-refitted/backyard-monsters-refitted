import { KorathReward, Reward } from "../../../enums/Rewards";
import { FieldData, Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";

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
  let rewards = userSave.rewards;
  const { KORATH, KRALLEN, DIAMOND_SPURTZ } = Reward;

  // Early return if all rewards are already assigned
  if (rewards[KORATH] && rewards[KRALLEN] && rewards[DIAMOND_SPURTZ]) return;

  const townHall = extractTownHall(userSave.buildingdata);
  if (!townHall || !townHall.l) return;

  let townHallLevel = townHall.l;

  // Town Hall Level 6
  if (townHallLevel >= 6 && !rewards[KORATH]) {
    rewards[KORATH] = { id: KORATH, value: KorathReward.FISTS_OF_DOOM };
  }

  // Town Hall Level 7
  if (townHallLevel >= 7 && !rewards[KRALLEN]) {
    rewards[KRALLEN] = { id: KRALLEN, value: 1 };
    addKrallenData(userSave);
  }

  // Town Hall Level 8
  if (townHallLevel >= 8 && !rewards[DIAMOND_SPURTZ]) {
    rewards[DIAMOND_SPURTZ] = { id: DIAMOND_SPURTZ };
  }

  ORMContext.em.persistAndFlush(userSave);
};

/**
 * Returns the Town Hall building object contained in the given buildingData object.
 * Throws an error if the town hall cannot be found.
 *
 * The object is identified by checking the `t` (type) variable on the child objects.
 * If `t` is equal to 14, then it is considered a Town Hall.
 *
 * @param buildingData the buildingData object to search
 * @returns the townHall object found
 * @throws Error when townHall Object cannot be found
 */
const extractTownHall = (buildingData: FieldData) => {
  for (const key in buildingData) {
    const building = buildingData[key];

    if (building && building.t === 14) return building;
  }
  return null;
};

/**
 * Adds Krallen data to the user's save, including champion data and reward metadata.
 *
 * @param {Save} userSave - The user's save data to update.
 */
const addKrallenData = (userSave: Save) => {
  const championData = parseChampionData(userSave.champion);

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
  }
};

/**
 * Parses the champion data from the user's save.
 *
 * The function ensures compatibility with different formats of the `champion` field:
 * - If the `champion` field is a string, it parses it into an object/array.
 * - If the `champion` field is already an object/array, it is returned as-is.
 * - Defaults to an empty array if the `champion` field is null or undefined.
 *
 * @param {string | object | null | undefined} rawChampionData - The raw champion data from the user's save.
 * @returns {object[]} The parsed champion data as an array of objects.
 */
const parseChampionData = (rawChampionData: any) => {
  if (typeof rawChampionData === "string")
    return JSON.parse(rawChampionData || "[]");

  return rawChampionData;
};
