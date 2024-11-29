import { BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { World } from "../../../models/world.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";

/**
 * Handles the process of a user leaving a world.
 *
 * Decrements the player count of the world the user is leaving.
 * Resets the user's save data associated with a world & removes their cells.
 *
 * @param {User} user - The user who is leaving the world.
 * @param {Save} save - The save data associated with the user.
 */
export const leaveWorld = async (user: User, save: Save) => {
  const world = await ORMContext.em.findOne(World, { uuid: save.worldid });

  if (world) {
    // Decrement the player count
    world.playerCount -= 1;
    await ORMContext.em.persistAndFlush(world);
  }

  // Reset the user's save data
  save.worldid = null;
  save.usemap = 0;
  save.cell = null;
  save.homebase = null;
  save.outposts = [];
  save.buildingresources = {};
  user.bookmarks = {};

  // Remove user's cells from the world
  await removeUserCells(user);
  await ORMContext.em.persistAndFlush([save, user]);
};

const removeUserCells = async (user: User) => {
  const { userid } = user;
  const homeBase = await ORMContext.em.findOne(WorldMapCell, { uid: userid });

  const outposts = await ORMContext.em.find(Save, {
    saveuserid: userid,
    type: BaseType.OUTPOST,
  });

  if (outposts && outposts.length > 0)
    await ORMContext.em.removeAndFlush(outposts);
  if (homeBase) await ORMContext.em.removeAndFlush(homeBase);
};
