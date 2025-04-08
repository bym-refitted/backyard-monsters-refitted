import { Status } from "../../enums/StatusCodes";
import { loadFailureErr, mailboxErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";

import { errorLog } from "../../utils/logger";
import { ORMContext } from "../../server";
import { Thread } from "../../models/thread.model";
import { Message } from "../../models/message.model";
import { FilterFrontendKeys } from "../../utils/FrontendKey";

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
    const threads = await ORMContext.em.find(
      Thread,
      {
        $or: [{ userid: user.userid }, { targetid: user.userid }],
      },
      { populate: ["lastMessage"] }
    );

    const threadMessages = threads.map((thread, index) => {
      const { lastMessage } = thread;
      const isSender = lastMessage.userid === user.userid;

      lastMessage.selectUnread(user.userid);

      lastMessage.messageid = index.toString();
      lastMessage.messagecount = thread.messagecount;
      lastMessage.userid = isSender ? lastMessage.targetid : lastMessage.userid;

      return lastMessage;
    });

    const threadsList = Object.fromEntries(
      threadMessages.map((thread: Thread) => [
        thread.threadid,
        FilterFrontendKeys(thread),
      ])
    );

    ctx.status = Status.OK;
    ctx.body = { error: 0, threads: threadsList };
  } catch (err) {
    throw mailboxErr();
  }
};
