import { SaveKeys } from "../../../../enums/SaveKeys";
import { permissionErr } from "../../../../errors/errors";
import { Save } from "../../../../models/save.model";
import { ChampionData } from "../zod/ChampionDataSchema";
/**
 * Handler for champion data validation during an attack.
 *
 * The client tracks champion stats during an attack using the `attackerchampion` property.
 *
 * @param {string} championData - The updated raw champion data to be validated and saved.
 * @param {Save} userSave - The user save from the database to access the original champion data.
 * @throws an error if the validation fails.
 */
export const championAttackHandler = (championData: ChampionData[], userSave: Save) => {
  if (!championData) throw permissionErr();

  const originalChampionData = userSave[SaveKeys.CHAMPION];

  // FIXME: This code makes no sense anymore. This function throws an error if either the userSave or the request body are null
  if (originalChampionData === null) {
    if (championData !== null) throw permissionErr();
    userSave[SaveKeys.CHAMPION] = championData;
    return;
  }

  if (championData) {

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
    userSave[SaveKeys.CHAMPION] = championData;
  }
};
