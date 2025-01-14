import { SaveKeys } from "../../../../enums/SaveKeys";
import { permissionErr } from "../../../../errors/errors";
import { Save } from "../../../../models/save.model";
import { parseChampionData } from "../../../../utils/parseChampionData";

/**
 * Handles the champion data validation and update.
 *
 * @param {any} value - The new champion data to be validated and saved.
 * @param {Save} baseSave - The current save data from the database.
 * @throws an error if the validation fails.
 */
export const championHandler = async (value: any, baseSave: Save) => {
  if (!value) throw permissionErr();

  const championData = parseChampionData(value);
  const originalChampionData = parseChampionData(baseSave[SaveKeys.CHAMPION]);

  if (originalChampionData === null) {
    if (value !== "null") throw permissionErr();
    baseSave[SaveKeys.CHAMPION] = value;
    return;
  }

  if (!Array.isArray(championData)) throw permissionErr();

  if (championData.length !== originalChampionData.length)
    throw permissionErr();

  for (let i = 0; i < championData.length; i++) {
    const champion = championData[i];
    const originalChampion = originalChampionData[i];

    for (const key in champion) {
      const isStatModified =
        key !== "hp" && champion[key] !== originalChampion[key];

      if (isStatModified) throw permissionErr();
    }
  }

  // Persist the new champion data if validation passes
  baseSave[SaveKeys.CHAMPION] = JSON.stringify(championData);
};
