import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { Tribes } from "../../../enums/Tribes";
import { legionnaire } from "../../../data/tribes/legionnaire";
import { abunaki } from "../../../data/tribes/abunaki";
import { dreadnaught } from "../../../data/tribes/dreadnaught";
import { kozu } from "../../../data/tribes/kozu";

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
  const baseId = parseInt(baseid);

  const cellX = Math.floor(baseId / 1000) % 1000;
  const cellY = baseId % 1000;

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const wmid = tribeIndex * 10 + 1;

  const { tribeSave } = fetchTribeData(tribeIndex);

  // Return a new save for the wild monster.
  return ORMContext.em.create(Save, {
    ...tribeSave,
    baseid,
    wmid,
    homebase: [cellX.toString(), cellY.toString()],
  });
};

/**
 * Fetches the tribe data based on the given tribe index.
 *
 * @param {number} tribeIndex - The tribe index.
 * @returns {object} - An object containing the tribe save data.
 */
const fetchTribeData = (tribeIndex: number) => {
  const tribes = [legionnaire, kozu, abunaki, dreadnaught];
  const selectedTribe = tribes[tribeIndex];

  // Get all keys from the selected tribe
  const keys = Object.keys(selectedTribe);

  // TODO: Should be based off levels not random
  // Select a random key
  const randomKey = keys[Math.floor(Math.random() * keys.length)];
  const tribeSave = selectedTribe[randomKey];

  return { tribeSave };
};
