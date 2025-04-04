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

const LOG_LEVEL = {
  INFO: "info",
  ERROR: "err",
};
interface DebugData {
  key: string;
  saveid: string;
  value: string;
}


/**
 * Controller to record debug data.
 *
 * This controller logs debug information sent from the client. It logs either an
 * error or info message depending on the key provided by the client. 
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
