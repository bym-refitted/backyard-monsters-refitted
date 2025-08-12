import { BaseType } from "../../../enums/Base";
import { MapRoomCell } from "../../../enums/MapRoom";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { World } from "../../../models/world.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";

/**
 * Handles the process of a user leaving a world. 
 * 
 * This function performs a complete cleanup when a user exits a world: 
 * decrements the world's player count, removes the user's homebase cell from the world map, 
 * deletes all outpost saves and their associated map cells (via cascade), 
 * and clears world-specific data from the user's main save, 
 * 
 * @param {User} user - The user who is leaving the world
 * @param {Save} save - The user's main save data associated with the world
 * @returns Resolves when the user has been completely removed from the world
 */
export const leaveWorld = async (user: User, save: Save) => {
  if (!save.worldid) return;

  const { userid } = user;
  const worldid = save.worldid;

  await ORMContext.em.transactional(async (em) => {
    const entitiesToRemove: (WorldMapCell | Save)[] = [];

    const [world, homeCell, outpostSaves] = await Promise.all([
      em.findOne(World, { uuid: worldid }),
      em.findOne(WorldMapCell, {
        uid: userid,
        base_type: MapRoomCell.HOMECELL,
      }),
      em.find(Save, {
        userid: userid,
        type: BaseType.OUTPOST,
      }),
    ]);

    // Decrement world player count
    if (world) {
      world.playerCount -= 1;
      em.persist(world);
    }

    if (homeCell) entitiesToRemove.push(homeCell);
    if (outpostSaves.length > 0) entitiesToRemove.push(...outpostSaves);

    if (entitiesToRemove.length > 0) em.remove(entitiesToRemove);

    // Reset the user's save data
    save.worldid = null;
    save.usemap = 0;
    save.cell = null;
    save.homebase = null;
    save.outposts = [];
    save.buildingresources = {};

    user.bookmarks = {};

    em.persist([save, user]);
  });
};
