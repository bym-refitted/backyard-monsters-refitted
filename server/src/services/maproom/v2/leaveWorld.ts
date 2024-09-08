import { BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";

/**
 * Handles the process of a user leaving a world.
 * Resets the user's save data associated with a world
 * & removes their cells from the world.
 *
 * @param {User} user - The user who is leaving the world.
 * @param {Save} save - The save data associated with the user.
 */
export const leaveWorld = async (user: User, save: Save) => {
  save.worldid = "";
  save.cell = null;
  save.homebase = null;
  save.outposts = [];
  save.usemap = 0;

  await removeUserCells(user);
  await ORMContext.em.persistAndFlush(save);
};

const removeUserCells = async (user: User) => {
  const homeBase = await ORMContext.em.findOne(WorldMapCell, {
    uid: user.userid,
  });

  const outposts = await ORMContext.em.find(Save, {
    saveuserid: user.userid,
    type: BaseType.OUTPOST,
  });

  if (outposts && outposts.length > 0)
    await ORMContext.em.removeAndFlush(outposts);
  if (homeBase) await ORMContext.em.removeAndFlush(homeBase);
};
