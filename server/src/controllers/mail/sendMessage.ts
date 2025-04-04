import { Status } from "../../enums/StatusCodes";
import { saveFailureErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";
import { devConfig } from "../../config/DevSettings";
import { SendMessageSchema } from "./zod/SendMessageSchema";
import { Thread } from "../../models/thread.model";
import { ORMContext } from "../../server";
import { Message } from "../../models/message.model";
import { errorLog, logging } from "../../utils/logger";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime";

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
    const user: User = ctx.authUser;
    const { type, targetid, subject, message, threadid } = SendMessageSchema.parse(ctx.request.body);
    const isAllowedToSend = devConfig.allowedMessageType[type];
    if (!isAllowedToSend) {
      ctx.status = Status.OK;
      ctx.body = { error: 1 };
      return;
    }
    
    logging(`check thread of ${threadid} with user of ${user.userid} to ${targetid}`);
    const newThread = await Thread.findOrCreateThread(threadid, user.userid, targetid);
    let messageCount = 0;
    if (threadid === 0 || newThread.threadid !== threadid) {
      messageCount++;
    }
    const messageTargetId = user.userid === newThread.userid ? newThread.targetid : newThread.userid;
    logging(`send message from ${user.userid} to ${messageTargetId}`);
    const newMessage = await ORMContext.em.create(Message, {
      threadid: newThread.threadid.toString(),
      userid: user.userid,
      targetid: messageTargetId,
      messagetype: type,
      userUnread: 0,
      targetUnread: 1,
      subject,
      message,
      updatetime: getCurrentDateTime()
    });

    newThread.messagecount++;
    newThread.lastMessage = newMessage;
    await ORMContext.em.persistAndFlush(newThread);
    const count = await ORMContext.em.count(Message, {
      $or: [
        {
          userid: messageTargetId,
          userUnread: 1
        },
        {
          targetid: messageTargetId,
          targetUnread: 1
        }
      ]
    });
    const targetUser = await ORMContext.em.findOne(User, { userid: messageTargetId }, { populate: ["save"] });
    if (!targetUser) {
      ctx.status = Status.OK;
      ctx.body = { error: 1 };
      return;
    }
    targetUser.save.unreadmessages = count;

    await ORMContext.em.persistAndFlush(targetUser);
    ctx.status = Status.OK;
    ctx.body = { 
      error: 0,
      threadid: newThread.threadid,
      messageid: 0
    };
  } catch (err) {
    errorLog(err);
    ctx.status = Status.OK;
    ctx.body = { error: 1 };
  }
};
