import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { BaseMode } from "../../../../enums/Base";
import { logging } from "../../../../utils/logger";
import { KorathReward, Reward } from "../../../../enums/Rewards";

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

  // Fetch base based on the provided baseid.
  if (baseid !== BaseMode.DEFAULT && BigInt(baseid) !== userSave.baseid) {
    let baseSave = await ORMContext.em.findOne(Save, {
      baseid: BigInt(baseid),
    });

    if (!baseSave) throw new Error(`Base save not found for baseid: ${baseid}`);
    return baseSave;
  }
  // Add reward for Diamond Spurtz Cannons & Korath at Town Hall 6.
  const townHall = userSave.buildingdata["0"];

  if (townHall && townHall.l >= 6) {
    userSave.rewards = {
      [Reward.DIAMOND_SPURTZ]: { id: Reward.DIAMOND_SPURTZ },
      [Reward.KORATH]: { id: Reward.KORATH, value: KorathReward.FISTS_OF_DOOM },
      ...userSave.rewards,
    };
  }

  return userSave;
};
