import { Status } from "../../enums/StatusCodes";
import { loadFailureErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { Message } from "../../models/message.model";
import { KoaController } from "../../utils/KoaController";

import { errorLog } from "../../utils/logger";
import { createDictionary } from "../../utils/createDictionary";

/**
 * Controller to get threads for MailBox.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageThreads: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  try {
    const threads = await Message.findUserMessages(user, { messagecount: { $exists: true, $gt: 0 } });
    ctx.body = {
      threads: createDictionary(threads, 'threadid')
    };
    ctx.status = Status.OK;

  } catch (err) {
    errorLog(`Failed to get thread list for user:${user.userid}`, err);
    throw loadFailureErr();
  }
};
