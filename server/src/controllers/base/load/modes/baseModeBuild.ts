import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { BaseMode } from "../../../../enums/Base";
import { logging } from "../../../../utils/logger";
import { balancedReward } from "../../../../services/base/balancedReward";
import { resetInvasionWaves } from "../../../../services/events/wmi/invasionUtils";
import { permissionErr } from "../../../../errors/errors";

/**
 * Retrieves the save data for the user based on the provided `baseid`.
 * If the baseid matches the user's save, it returns the existing save.
 * Otherwise, it attempts to find and load the requested base.
 * If no save is found for the baseid, return null.
 *
 * @param {User} user - The authenticated user object.
 * @param {string} baseid - The base identifier for the requested save.
 * @returns {Promise<Save | null>} The user's save object or null if not found.
 */
export const baseModeBuild = async (user: User, baseid: string) => {
  let userSave: Save = user.save;

  // If no user save is found, setup MR1 & create a default save for the user.
  if (!userSave) {
    logging("User save not found; creating a default save.");
    return await Save.createMainSave(ORMContext.em, user);
  }

  // Default mode only runs once on initial base load
  if (baseid === BaseMode.DEFAULT) {
    await balancedReward(userSave);

    if (userSave.stats?.other) resetInvasionWaves(userSave.stats.other);

    await ORMContext.em.persistAndFlush(userSave);
    return userSave;
  }

  if (baseid !== userSave.baseid) {
    const baseSave = await ORMContext.em.findOne(Save, { baseid });

    if (!baseSave) throw new Error(`Base save not found for baseid: ${baseid}`);
    if (baseSave.userid !== user.userid) throw permissionErr();
    
    return baseSave;
  }

  return userSave;
};
