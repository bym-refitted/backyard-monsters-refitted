import { Status } from "../../enums/StatusCodes.js";
import { mailboxErr } from "../../errors/errors.js";
import { User } from "../../database/models/user.model.js";
import type { KoaController } from "../../utils/KoaController.js";

import { postgres } from "../../server.js";
import { MigrateStatus } from "../../enums/MigrateStatus.js";
import { Thread } from "../../database/models/thread.model.js";
import { WorldMapCell } from "../../database/models/worldmapcell.model.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";
import { logger } from "../../utils/logger.js";

/** All the client needs of an offered outpost: which it is, and where to look at it. */
const INVITED_CELL_FIELDS = ["baseid", "x", "y", "world"] as const;

/**
 * Controller to get threads for mailbox.
 *
 * Retrieves message threads for the authenticated user.
 * Populates the last message in each thread and formats the response.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageThreads: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  try {
    const threads = await postgres.em.find(
      Thread,
      {
        $or: [{ userid: user.userid }, { targetid: user.userid }],
      },
      { populate: ["lastMessage"] }
    );

    const blockedUsers = new Set(user.blockedUsers);

    // Filter out threads with blocked users and ensure they have lastMessage
    const filteredThreads = threads.filter((thread) => {
      const targetUser = thread.userid === user.userid ? thread.targetid : thread.userid;
      return thread.lastMessage && !blockedUsers.has(targetUser);
    });

    // Only an open invitation needs its outpost
    const invitedBaseids = filteredThreads.flatMap((thread) => {
      const baseid = thread.migrate_baseid;
      const inviteIsOpen = thread.migratestate === MigrateStatus.REQUESTED;

      return inviteIsOpen && baseid ? [baseid] : [];
    });

    const invitedCells = invitedBaseids.length
      ? await postgres.em.find(WorldMapCell, { baseid: { $in: invitedBaseids } }, { fields: INVITED_CELL_FIELDS })
      : [];

    const outposts = new Map(invitedCells.map((cell) => [cell.baseid, cell]));

    const threadMessages = filteredThreads.flatMap((thread, index) => {
      if (!thread.lastMessage) return [];

      const lastMessage = thread.lastMessage;
      const isSender = lastMessage.userid === user.userid;

      lastMessage.selectUnread(user.userid);

      lastMessage.messageid = index.toString();
      lastMessage.messagecount = thread.messagecount;
      lastMessage.trucestate = thread.trucestate ?? null;
      lastMessage.migratestate = thread.migratestate ?? null;

      const outpost = thread.migrate_baseid ? outposts.get(thread.migrate_baseid) : undefined;

      if (outpost) {
        lastMessage.baseid = outpost.baseid;
        lastMessage.coords = [outpost.x, outpost.y];
        lastMessage.worldid = outpost.world.uuid;
      }

      lastMessage.userid = isSender ? lastMessage.targetid : lastMessage.userid;
      lastMessage.reportid = "0";

      return [lastMessage];
    });

    const threadsList = Object.fromEntries(
      threadMessages.map((message) => [
        message.threadid,
        FilterFrontendKeys(message),
      ])
    );

    ctx.status = Status.OK;
    ctx.body = { error: 0, threads: threadsList };
  } catch (err) {
    logger.error(`Error getting message threads: ${err}`);
    throw mailboxErr();
  }
};
