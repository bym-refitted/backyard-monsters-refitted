import { MapRoomCell, MapRoomVersion } from "../../enums/MapRoom.js";
import { MigrateStatus } from "../../enums/MigrateStatus.js";
import { Thread } from "../../database/models/thread.model.js";
import { WorldMapCell } from "../../database/models/worldmapcell.model.js";
import { areFriends } from "../friends/friendList.js";
import { permissionErr } from "../../errors/errors.js";
import { postgres } from "../../server.js";

export interface InviteRecipient {
  userid: number;
  mapversion: number;
  worldid?: string | null;
}

/**
 * Offers one of the sender's outposts to a friend, so they can move their yard onto it.
 *
 * Friends only, and only an outpost the sender actually owns in the world the recipient
 * is in - accepting moves the recipient's home onto that cell, so an invitation to
 * somebody else's outpost, or to another world, would be meaningless. The sender's own
 * world is the outpost's, since an outpost cannot be held in a world they have left.
 *
 * One open invitation per outpost: offering it to a second player while the first has
 * not answered would let both accept the same cell.
 *
 * @param {number} userid - The player offering the outpost.
 * @param {InviteRecipient} recipient - The friend being invited, as the mailbox already loaded them.
 * @param {string | undefined} baseid - The outpost being offered.
 * @param {Thread} thread - The mailbox thread carrying the invitation.
 * @returns {Promise<void>}
 */
export const handleMigrateInvite = async (userid: number, recipient: InviteRecipient, baseid: string | undefined, thread: Thread) => {
  if (!baseid) throw permissionErr();
  if (recipient.mapversion !== MapRoomVersion.V2) throw permissionErr();

  const [friends, outpost, openInvite] = await Promise.all([
    areFriends(userid, recipient.userid),

    postgres.em.findOne(WorldMapCell, {
      baseid,
      uid: userid,
      base_type: MapRoomCell.OUTPOST,
      map_version: MapRoomVersion.V2,
    }),

    postgres.em.findOne(Thread, { migrate_baseid: baseid, migratestate: MigrateStatus.REQUESTED }),
  ]);

  if (!friends || !outpost) throw permissionErr();
  if (outpost.world.uuid !== recipient.worldid) throw permissionErr();
  if (openInvite && openInvite.threadid !== thread.threadid) throw permissionErr();

  thread.migrate_baseid = baseid;
  thread.migratestate = MigrateStatus.REQUESTED;
};

/**
 * Withdraws an invitation the sender made, while the friend has yet to answer it.
 *
 * @param {number} userid - The player who made the invitation.
 * @param {Thread} thread - The thread carrying it.
 * @returns {Promise<void>}
 */
export const handleMigrateRevoke = async (userid: number, thread: Thread) => {
  if (thread.migratestate !== MigrateStatus.REQUESTED) throw permissionErr();
  if (thread.userid !== userid) throw permissionErr();

  thread.migratestate = MigrateStatus.REVOKED;
};
