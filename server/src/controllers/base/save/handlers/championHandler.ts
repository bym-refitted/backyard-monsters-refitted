import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { permissionErr } from "../../../../errors/errors.js";
import { Save } from "../../../../models/save.model.js";
import { parseChampionData } from "../../../../utils/parseChampionData.js";

/**
 * =================================
 * NOT CURRENTLY IN USE 
 * =================================
 * 
 * Handler for champion data validation during an attack.
 *
 * The client tracks champion stats during an attack using the `attackerchampion` property.
 *
 * @param {string} rawChampionData - The updated raw champion data to be validated and saved.
 * @param {Save} userSave - The user save from the database to access the original champion data.
 * @throws an error if the validation fails.
 */
export const championHandler = async (rawChampionData: string, userSave: Save) => {
  if (!rawChampionData) throw permissionErr();

  const championData = parseChampionData(rawChampionData);
  const originalChampionData = parseChampionData(userSave[SaveKeys.CHAMPION]);

  if (originalChampionData === null) {
    if (rawChampionData !== "null") throw permissionErr();
    userSave[SaveKeys.CHAMPION] = rawChampionData;
    
    return;
  }

  if (championData) {
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
    userSave[SaveKeys.CHAMPION] = JSON.stringify(championData);
  }
};
