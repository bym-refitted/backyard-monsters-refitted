import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { BaseMode } from "../../../../enums/Base";
import { errorLog, logging } from "../../../../utils/logger";

/**
 * Retrieves the save data for the user based on the provided `baseid`.
 * If the baseid matches the user's save, it returns the existing save.
 * Otherwise, it attempts to find and load the requested base.
 * If no save is found for the baseid, return null.
 *
 * @param {User} user - The authenticated user object.
 * @param {string} baseid - The base identifier for the requested save.
 * @returns {Promise<Save>} The user's save object or a newly created save if no match is found.
 */
export const baseModeBuild = async (user: User, baseid: string) => {
  const userSave: Save = user.save;

  if (!userSave) {
    logging("User save not found; creating a default save.");
    return Save.createDefaultUserSave(ORMContext.em, user);
  }

  if (baseid === BaseMode.DEFAULT || baseid === userSave.baseid)
    return userSave;

  const save = await ORMContext.em.findOne(Save, { baseid });
  // If the save belongs to the user, return it.
  if (save && save.saveuserid === user.userid) return save;

  errorLog("No valid save found.");
  return null;
};
