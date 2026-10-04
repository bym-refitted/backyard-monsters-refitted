import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { postgres } from "../../../server.js";
import { removeDefenders } from "./removeDefenders.js";

/**
 * Frees the player's position in their world without taking them out of it.
 * Used when relocating next to a friend who shares the world.
 *
 * Captured resources and strongholds, and the defenders guarding them, are untouched -
 * they keep their cells, saves and places in the outpost list.
 *
 * No-ops if the user is not in a world, or has no home cell to vacate.
 * All operations run inside a single transaction.
 *
 * @param {User} user - The user moving within their world.
 * @param {Save} save - The user's main save.
 * @returns {Promise<void>}
 */
export const leavePosition = async (user: User, save: Save) => {
  if (!save.worldid) return;

  const worldid = save.worldid;
  const { userid } = user;

  await postgres.em.transactional(async (em) => {
    const homeCell = await em.findOne(WorldMapCell, {
      uid: userid,
      world: worldid,
      map_version: MapRoomVersion.V3,
      base_type: EnumYardType.PLAYER,
    });

    if (!homeCell) return;

    const ownDefenderBaseids = await removeDefenders(em, worldid, homeCell, userid);

    if (ownDefenderBaseids.length > 0) {
      await em.nativeDelete(Save, { baseid: { $in: ownDefenderBaseids } });

      save.outposts = save.outposts.filter((outpost) => !ownDefenderBaseids.includes(outpost[2]));
    }

    save.cell = undefined;
    save.homebase = null;

    em.remove(homeCell);
    em.persist(save);

    await em.flush();
  });
};
