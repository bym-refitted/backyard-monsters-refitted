import { Status } from "../../enums/StatusCodes.js";
import { KoaController } from "../../utils/KoaController.js";
import { ReportMessageSchema } from "./zod/ReportMessageSchema.js";
import { postgres } from "../../server.js";
import { Thread } from "../../models/thread.model.js";
import { User } from "../../models/user.model.js";
import { mailboxErr } from "../../errors/errors.js";
import { logger } from "../../utils/logger.js";

/**
 * Controller to report/block a user from a message thread
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const reportMessageThread: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;
    const { threadid } = ReportMessageSchema.parse(ctx.request.body);

    const thread = await postgres.em.findOne(Thread, { threadid });

    if (!thread) throw mailboxErr();

    // Determine the other user in the thread
    const blockedUserId = thread.userid === user.userid ? thread.targetid : thread.userid;

    if (user.blockedUsers.includes(blockedUserId)) {
      ctx.status = Status.OK;
      ctx.body = { error: 0 };
      return;
    }

    user.blockedUsers.push(blockedUserId);
    await postgres.em.persistAndFlush(user);

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (error) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
    logger.error("Error blocking user:", error);
  }
};
