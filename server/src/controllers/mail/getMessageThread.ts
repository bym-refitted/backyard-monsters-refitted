import { Status } from "../../enums/StatusCodes.js";
import { mailboxErr } from "../../errors/errors.js";
import { User } from "../../models/user.model.js";
import { KoaController } from "../../utils/KoaController.js";
import { postgres } from "../../server.js";
import { GetMessageSchema } from "./zod/GetMessageSchema.js";
import { countUnreadMessage } from "../../services/mail/countUnreadMessage.js";
import { findUserMessages } from "../../services/mail/findUserMessages.js";
import { Message } from "../../models/message.model.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";

/**
 * Controller to get multiple messages with single threadid.
 * This function retrieves messages for a specific thread and marks them as read if necessary.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageThread: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;
    const userSave = user.save;
    await postgres.em.populate(user, ["save"]);

    const { threadid } = GetMessageSchema.parse(ctx.request.body);

    const messages = await findUserMessages(user, { threadid });
    const hasUnreadMessage = messages.some((message) => message.unread === 1);

    if (hasUnreadMessage) {
      messages.forEach((message) => {
        if (message.userid === user.userid) {
          message.userUnread = 0;
          message.unread = 0;
        } else {
          message.targetUnread = 0;
          message.unread = 0;
        }
      });

      await postgres.em.persistAndFlush(messages);

      const count = await countUnreadMessage(user.userid);

      userSave.unreadmessages = count;
      await postgres.em.flush();
    }

    const thread = Object.fromEntries(
      messages.map((message: Message) => [
        message.messageid,
        FilterFrontendKeys(message),
      ])
    );

    ctx.status = Status.OK;
    ctx.body = { error: 0, thread };
  } catch (err) {
    throw mailboxErr();
  }
};
