import { MigrateStatus } from "../../enums/MigrateStatus.js";
import { Thread } from "../../database/models/thread.model.js";
import { postgres } from "../../server.js";

/**
 * The outposts this player has an unanswered move-in invitation on.
 *
 * The map room marks those outposts so their owner can see an invitation is still open,
 * and withdrawing one needs the thread it was sent on - which is what the map room sends
 * back when the owner presses revoke.
 *
 * @param {number} userid - The player whose map room is being drawn.
 * @returns {Promise<Map<string, number>>} Outpost baseid to the thread carrying its invitation.
 */
export const getPendingInvites = async (userid: number): Promise<Map<string, number>> => {
  const threads = await postgres.em.find(
    Thread,
    {
      migratestate: MigrateStatus.REQUESTED,
      $or: [{ userid }, { targetid: userid }],
    },
    { fields: ["threadid", "migrate_baseid"] }
  );

  return new Map<string, number>(
    threads.flatMap((thread) => (thread.migrate_baseid ? [[thread.migrate_baseid, thread.threadid]] : []))
  );
};
