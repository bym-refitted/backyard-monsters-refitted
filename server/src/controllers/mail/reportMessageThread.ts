import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";
import { ReportMessageSchema } from "./zod/ReportMessageSchema";
import { ORMContext } from "../../server";
import { Thread } from "../../models/thread.model";
import { User } from "../../models/user.model";
import { mailboxErr } from "../../errors/errors";
import { errorLog } from "../../utils/logger";

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

    const thread = await ORMContext.em.findOne(Thread, { threadid });

    if (!thread) throw mailboxErr();

    // Determine the other user in the thread
    const blockedUserId = thread.userid === user.userid ? thread.targetid : thread.userid;

    if (user.blockedUsers.includes(blockedUserId)) {
      ctx.status = Status.OK;
      ctx.body = { error: 0 };
      return;
    }

    user.blockedUsers.push(blockedUserId);
    await ORMContext.em.persistAndFlush(user);

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (error) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
    errorLog("Error blocking user:", error);
  }
};
