import { Status } from "../../enums/StatusCodes";
import { debugClientErr, loadFailureErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";

import { ORMContext } from "../../server";
import { Message } from "../../models/message.model";
import { createDictionary } from "../../utils/createDictionary";
import { Save } from "../../models/save.model";
import { GetMessageSchema } from "./zod/GetMessageSchema";

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
      ctx.body = {
        error: 1,
        thread: {}
      };
      return;
    }
    ctx.status = Status.OK;
    const messages = await Message.findUserMessages(user, { threadid });
    const hasUnreadMessage = messages.some(message => message.unread === 1);
    messages.forEach(message => {
      message.setAsRead(user.userid);
    });

    if (hasUnreadMessage) {
      await ORMContext.em.persistAndFlush(messages);
      if (user.save?.basesaveid) {
        const count = await ORMContext.em.count(Message, {
          $or: [
            { 
              userid: user.userid,
              userUnread: 1
            },
            { 
              targetid: user.userid,
              targetUnread: 1
            }
          ]
        });
        await ORMContext.em.populate(user, ["save"]);
        user.save.unreadmessages = count;

        await ORMContext.em.flush();
      }
    }
    ctx.body = {
      error: 0,
      thread: createDictionary(messages, 'messageid')
    };

  } catch (err) {
    throw debugClientErr();
  }
};


