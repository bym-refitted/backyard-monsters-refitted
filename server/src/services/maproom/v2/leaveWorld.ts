import { raw } from "@mikro-orm/core";

import { BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { World } from "../../../database/models/world.model.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { postgres } from "../../../server.js";
import { removeDefenders } from "../v3/removeDefenders.js";

/**
 * Removes a user from their current Map Room world, cleaning up all associated data atomically.
 *
 * Handles the full teardown sequence:
 * - Decrements the world's player count
 * - Removes the user's home cell and all fortification cells at their defender positions
 * - Cleans up any foreign-owned defender outposts that were occupying the user's defender slots,
 *   removing them from the respective owners' outpost lists and deleting their saves
 * - Deletes all of the user's outpost saves and map cells
 * - Nulls the user's main save world state (worldid, homebase, cell, outposts, buildingresources)
 * - Nulls infernosave.worldid so the user is immediately removed from inferno neighbour lists
 *
 * No-ops if the user is not currently in a world.
 * All operations run inside a single transaction.
 *
 * @param {User} user - The user leaving the world
 * @param {Save} save - The user's main save
 * @returns {Promise<void>}
 */
export const leaveWorld = async (user: User, save: Save) => {
  if (!save.worldid) return;

  const { userid } = user;
  const worldid = save.worldid;

  await postgres.em.transactional(async (em) => {
    await em.nativeUpdate(World, { uuid: worldid }, { playerCount: raw("player_count - 1") });

    const homeCell = await em.findOne(WorldMapCell, {
      uid: userid,
      world: worldid,
      map_version: MapRoomVersion.V3,
      base_type: EnumYardType.PLAYER,
    });

    if (homeCell) await removeDefenders(em, worldid, homeCell, userid);

    await em.nativeDelete(Save, { userid, type: BaseType.OUTPOST });
    await em.nativeDelete(WorldMapCell, { uid: userid });

    save.worldid = null;
    save.usemap = 0;
    save.cell = undefined;
    save.homebase = null;
    save.outposts = [];
    save.buildingresources = {};

    user.bookmarks = {};

    // Null inferno worldid so the user is immediately excluded from inferno neighbour queries.
    await em.populate(user, ["infernosave"]);

    const toPersist: (Save | User)[] = [save, user];

    if (user.infernosave) {
      user.infernosave.worldid = null;
      toPersist.push(user.infernosave);
    }

    em.persist(toPersist);
    await em.flush();
  });
};
