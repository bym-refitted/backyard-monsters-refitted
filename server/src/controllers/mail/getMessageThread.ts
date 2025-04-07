import { Status } from "../../enums/StatusCodes";
import { debugClientErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";

import { ORMContext } from "../../server";
import { createDictionary } from "../../utils/createDictionary";
import { GetMessageSchema } from "./zod/GetMessageSchema";
import { errorLog, logging } from "../../utils/logger";
import { countUnreadMessage } from "../../services/mail/countUnreadMessage";
import { findUserMessages } from "../../services/mail/findUserMessages";

/**
 * Controller to get multiple messages with single threadid for MailBox.
 *
 * This controller get single thread
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageThread: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;
    const { threadid } = GetMessageSchema.parse(ctx.request.body);

    if (!threadid) {
      errorLog(`thread id is required`, {});
      ctx.body = {
        error: 1,
        thread: {}
      };
      ctx.status = Status.OK;
      return;
    }
    const messages = await findUserMessages(user, { threadid });
    const hasUnreadMessage = messages.some(message => message.unread === 1);
    messages.forEach(message => {
      message.setAsRead(user.userid);
    });

    if (hasUnreadMessage) {
      await ORMContext.em.persistAndFlush(messages);
      if (user.save?.basesaveid) {
        logging(`count unread of user ID: ${user.userid}`);
        const count = await countUnreadMessage(user.userid);
        await ORMContext.em.populate(user, ["save"]);
        user.save.unreadmessages = count;

        await ORMContext.em.flush();
      }
    }
    ctx.body = {
      error: 0,
      thread: createDictionary(messages, 'messageid')
    };
    ctx.status = Status.OK;
  } catch (err) {
    throw debugClientErr();
  }
};


