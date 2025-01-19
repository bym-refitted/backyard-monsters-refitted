import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { BaseMode } from "../../../../enums/Base";
import { logging } from "../../../../utils/logger";
import { balancedReward } from "../balancedReward";
import { IncidentReport } from "../../../../models/incidentreport";

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

  // If no user save is found, create a default save for the user.
  if (!userSave) {
    logging("User save not found; creating a default save.");
    return await Save.createDefaultUserSave(ORMContext.em, user);
  }

  if (baseid === BaseMode.DEFAULT) {
    await balancedReward(userSave);
    return userSave;
  }

  if (BigInt(baseid) !== BigInt(userSave.baseid)) {
    const baseSave = await ORMContext.em.findOne(Save, {
      baseid: BigInt(baseid),
    });

    if (!baseSave) throw new Error(`Base save not found for baseid: ${baseid}`);
    
    if (baseSave.userid !== user.userid) {
      const incidentReport = new IncidentReport();
      
      incidentReport.userid = user.userid;
      incidentReport.username = user.username;
      incidentReport.discord_tag = user.discord_tag;
      incidentReport.report = {
        message: `Unauthorized access to baseid: ${baseid} from user ${user.username}`,
        baseid,
        timestamp: new Date().toISOString(),
      };

      await ORMContext.em.persistAndFlush(incidentReport);
      
      // Could log this user id somewhere?
      throw new Error(
        `Unauthorized access to baseid: ${baseid} from user ${user.username}`
      );
    }

    return baseSave;
  }

  return userSave;
};
