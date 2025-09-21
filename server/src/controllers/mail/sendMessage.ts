import { Status } from "../../enums/StatusCodes";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";
import { devConfig } from "../../config/DevSettings";
import { SendMessageSchema } from "./zod/SendMessageSchema";
import { ORMContext } from "../../server";
import { Message } from "../../models/message.model";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime";
import { findOrCreateThread } from "../../services/mail/findOrCreateThread";
import { countUnreadMessage } from "../../services/mail/countUnreadMessage";
import { mailboxErr } from "../../errors/errors";
import { errorLog } from "../../utils/logger";

/**
 * Controller to send message
 *
 * - request body with threadid 0 means it will create a new thread (via Compose / Message in Map Room)
 * - a thread starter will have correct request body for targetid
 * - another reply on a thread will always have request body for targetid set as current user,
 * so it need to be changed by getting up on the correct targetid when saved to DB
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const sendMessage: KoaController = async (ctx) => {
  try {
    const { userid, blockedUsers }: User = ctx.authUser;
    const message = SendMessageSchema.parse(ctx.request.body);

    const isAllowedToSend = devConfig.allowedMessageType[message.type];

    if (!isAllowedToSend) {
      ctx.status = Status.OK;
      ctx.body = { error: 1, message: "Message type disabled on server" };
      return;
    }

    // Profanity filter
    const { Filter } = await import("bad-words");
    const filter = new Filter();
    const filteredSubject = filter.clean(message.subject);
    const filteredMessage = filter.clean(message.message);

    const { threadid, targetid } = message;
    const thread = await findOrCreateThread(threadid, targetid, userid);

    const isSender = thread.userid === userid;
    const messageTargetId = isSender ? thread.targetid : thread.userid;

    const recipient = await ORMContext.em.findOne(
      User,
      { userid: messageTargetId },
      { populate: ["save"] }
    );

    if (!recipient) {
      ctx.status = Status.OK;
      ctx.body = { error: 1 };
      return;
    }

    // Check if either user has blocked the other
    if (blockedUsers.includes(messageTargetId) || recipient.blockedUsers.includes(userid)) {
      ctx.status = Status.OK;
      ctx.body = { error: 1, message: "Cannot send message to this user" };
      return;
    }

    const newMessage = ORMContext.em.create(Message, {
      threadid: thread.threadid,
      userid,
      targetid: messageTargetId,
      messagetype: message.type,
      userUnread: 0,
      targetUnread: 1,
      subject: filteredSubject,
      message: filteredMessage,
      updatetime: getCurrentDateTime(),
    });

    thread.messagecount++;
    thread.lastMessage = newMessage;
    await ORMContext.em.persistAndFlush(thread);

    const count = await countUnreadMessage(messageTargetId);

    recipient.save.unreadmessages = count;
    await ORMContext.em.persistAndFlush(recipient);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      messageid: 0,
      threadid: thread.threadid,
    };
  } catch (err) {
    errorLog("Error sending message:", err);
    throw mailboxErr();
  }
};
