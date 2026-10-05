import { MapRoomCell, MapRoomVersion } from "../../enums/MapRoom.js";
import { MigrateStatus } from "../../enums/MigrateStatus.js";
import { Thread } from "../../database/models/thread.model.js";
import { WorldMapCell } from "../../database/models/worldmapcell.model.js";
import { postgres } from "../../server.js";

/**
 * The world a player may look into, because a friend has invited them to move there.
 *
 * An invitation is the only reason to see a world that is not your own, so the world is
 * resolved from the invitation rather than taken from the request - naming a world is not
 * enough to be shown it.
 *
 * @param {number} userid - The player asking to look.
 * @param {string} worldid - The world they asked for.
 * @returns {Promise<string | null>} That world when an open invitation leads to it, otherwise null.
 */
export const getInvitedWorld = async (userid: number, worldid: string): Promise<string | null> => {
  const invites = await postgres.em.find(
    Thread,
    {
      migratestate: MigrateStatus.REQUESTED,
      $or: [{ userid }, { targetid: userid }],
    },
    { fields: ["migrate_baseid"] }
  );

  const baseids = invites.flatMap((invite) => (invite.migrate_baseid ? [invite.migrate_baseid] : []));

  if (!baseids.length) return null;

  const where = {
    baseid: { $in: baseids },
    base_type: MapRoomCell.OUTPOST,
    map_version: MapRoomVersion.V2,
    world: worldid,
  }

  const outpost = await postgres.em.findOne(WorldMapCell, where);

  return outpost ? worldid : null;
};
