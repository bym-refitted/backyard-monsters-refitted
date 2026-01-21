import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";
import { BaseMode } from "../../../../enums/Base.js";
import { logger } from "../../../../utils/logger.js";
import { balancedReward } from "../../../../services/base/balancedReward.js";
import { resetInvasionWaves } from "../../../../services/events/wmi/invasionUtils.js";
import { permissionErr } from "../../../../errors/errors.js";

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
    logger.info("User save not found; creating a default save.");
    return await Save.createMainSave(postgres.em, user);
  }

  // Default mode only runs once on initial base load
  if (baseid === BaseMode.DEFAULT) {
    await balancedReward(userSave);

    if (userSave.stats?.other) resetInvasionWaves(userSave.stats.other);

    await postgres.em.persistAndFlush(userSave);
    return userSave;
  }

  if (baseid !== userSave.baseid) {
    const baseSave = await postgres.em.findOne(Save, { baseid });

    if (!baseSave) throw new Error(`Base save not found for baseid: ${baseid}`);
    if (baseSave.userid !== user.userid) throw permissionErr();
    
    return baseSave;
  }

  return userSave;
};
