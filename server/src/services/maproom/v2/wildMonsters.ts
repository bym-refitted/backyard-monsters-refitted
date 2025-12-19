import { Save } from "../../../models/save.model";
import { postgres } from "../../../server";
import { Tribe, Tribes } from "../../../enums/Tribes";
import { legionnaire } from "../../../data/tribes/v2/legionnaire";
import { abunaki } from "../../../data/tribes/v2/abunaki";
import { dreadnaught } from "../../../data/tribes/v2/dreadnaught";
import { kozu } from "../../../data/tribes/v2/kozu";
import { calculateTribeLevel, minimumTribeLevels } from "./calculateTribeLevel";

/**
 * Generates a save for a wild monster based on the given base ID.
 *
 * The base ID is used to calculate the cell coordinates (`cellX`, `cellY`)
 * and derive a tribe index from the combined coordinates. Based on the tribe index,
 * it fetches tribe-specific save data and generates a `Save` object for a wild monster.
 *
 * @param {string} baseid - The base ID as a string, which will be converted to an integer.
 * @returns {Save} - A new `Save` object for the wild monster, with tribe-specific data.
 */
export const wildMonsterSave = (baseid: string) => {
  const cellX = parseInt(baseid.slice(-6, -3));
  const cellY = parseInt(baseid.slice(-3));

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const tribe = Tribes[tribeIndex] as Tribe;
  const wmid = tribeIndex * 10 + 1;

  const level = calculateTribeLevel(cellX, cellY, tribe);

  const { tribeSave } = fetchTribeData(tribeIndex, level);

  // Return a new save for the wild monster.
  return postgres.em.create(Save, {
    ...tribeSave,
    baseid,
    level,
    wmid
  });
};

/**
 * Fetches the tribe data based on the given tribe index.
 *
 * @param {number} tribeIndex - The tribe index.
 * @param {number} level - The level of the wild monster.
 * @returns {object} - An object containing the tribe save data.
 */
const fetchTribeData = (tribeIndex: number, level: number) => {
  const tribeData = [legionnaire, kozu, abunaki, dreadnaught];

  // Get the selected tribe
  const selectedTribe = tribeData[tribeIndex];
  const tribe = Tribes[tribeIndex] as Tribe;

  // Sort keys from selected tribe
  const keys = Object.keys(selectedTribe);
  const sortedKeys = keys.sort((a, b) => parseInt(a) - parseInt(b));

  // Get level range for this tribe
  const lowerLimit = minimumTribeLevels[tribe];
  const higherLimit = 45;
  const levelRange = higherLimit - lowerLimit;

  // Find the appropriate key based on the level
  const levelsPerKey = Math.ceil(levelRange / sortedKeys.length);
  let keyIndex = Math.floor((level - lowerLimit) / levelsPerKey);

  // Safety bounds
  keyIndex = Math.max(0, Math.min(keyIndex, sortedKeys.length - 1));

  const selectedKey = sortedKeys[keyIndex];
  const tribeSave = selectedTribe[selectedKey];

  return { tribeSave };
};
