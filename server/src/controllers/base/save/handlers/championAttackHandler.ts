import { SaveKeys } from "../../../../enums/SaveKeys";
import { permissionErr } from "../../../../errors/errors";
import { Save } from "../../../../models/save.model";
import { ChampionData } from "../zod/ChampionDataSchema";
/**
 * Handler for champion data validation during an attack.
 *
 * The client tracks champion stats during an attack using the `attackerchampion` property.
 *
 * @param {string} updatedChampionData - The updated champion data to be validated and saved.
 * @param {Save} userSave - The user save from the database to access the original champion data.
 * @throws an error if the validation fails.
 */
export const championAttackHandler = (updatedChampionData: ChampionData[], userSave: Save) => {
  if (!updatedChampionData) return;

  const originalChampionData = userSave[SaveKeys.CHAMPION];

  // if the user has no champion data in their save,
  // but sent data during an attack, they are probably cheating
  if (originalChampionData === null) {
    throw permissionErr();
  }

  if (updatedChampionData.length !== originalChampionData.length)
    // user has more or less champions than they had in their save,
    throw permissionErr();

  for (let i = 0; i < updatedChampionData.length; i++) {
    const champion = updatedChampionData[i];
    const originalChampion = originalChampionData[i];

    for (const key in champion) {
      const isStatModified =
        key !== "hp" && champion[key] !== originalChampion[key];

      if (isStatModified) throw permissionErr();
    }
  }

  // Persist the new champion data if validation passes
  userSave[SaveKeys.CHAMPION] = updatedChampionData;
};
