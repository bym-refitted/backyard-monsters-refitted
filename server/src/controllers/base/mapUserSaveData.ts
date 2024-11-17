import { User } from "../../models/user.model";

/**
 * Maps the common properties from the user save object
 * which apply to all user-owned bases
 * e.g. Main Yards & Outposts should return these common properties.
 *
 * @param {User["save"]} userSave - The save object.
 * @returns {Object} An object containing the mapped properties.
 */
export const mapUserSaveData = (user: User) => {
  const userSave = user.save;

  return {
    credits: userSave.credits,
    resources: userSave.resources,
    lockerdata: userSave.lockerdata,
    academy: userSave.academy,
    outposts: userSave.outposts,
    quests: userSave.quests,
    points: userSave.points,
    basevalue: userSave.basevalue,
    buildingresources: userSave.buildingresources,
    researchdata: userSave.researchdata,
    rewards: userSave.rewards,
    // savetime: userSave.savetime,
  };
};
