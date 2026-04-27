import z from "zod";

import { Status } from "../../enums/StatusCodes.js";
import { TruceStatus } from "../../enums/TruceStatus.js";
import { Message } from "../../models/message.model.js";
import { Save } from "../../models/save.model.js";
import { Truce } from "../../models/truce.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { countUnreadMessage } from "../../services/mail/countUnreadMessage.js";
import { findOrCreateThread } from "../../services/mail/findOrCreateThread.js";
import type { MessageData } from "../../types/EntityData.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import type { KoaController } from "../../utils/KoaController.js";
import { mailboxErr, permissionErr } from "../../errors/errors.js";

/**
 * Duration (in seconds) for which a truce remains active after being accepted.
 * After this period, the truce expires and a new request can be made.
 * Currently set to 14 days.
 */
export const TRUCE_DURATION = 14 * 24 * 60 * 60;

const TruceSchema = z.object({
  baseid: z.string(),
  message: z.string().max(580).min(1),
});

/**
 * Creates a truce request between the authenticated user and the owner of the given base.
 *
 * - Resolves the target player from the provided baseid
 * - Guards against self-truces, duplicate pending requests, and unexpired active truces
 * - Creates a Truce record and a mailbox thread with the initial request message
 *
 * @param {Context} ctx - Koa context. Expects baseid and message in the request body.
 */
export const requestTruce: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const { baseid, message } = TruceSchema.parse(ctx.request.body);

  const targetSave = await postgres.em.findOne(Save, { baseid });

  if (!targetSave) throw mailboxErr();

  if (targetSave.saveuserid === user.userid) throw permissionErr();

  const targetUserid = targetSave.saveuserid;

  const existingTruce = await postgres.em.findOne(Truce, {
    $and: [
      {
        $or: [
          { initiator_userid: user.userid, recipient_userid: targetUserid },
          { initiator_userid: targetUserid, recipient_userid: user.userid },
        ],
      },
      {
        $or: [
          { status: TruceStatus.REQUESTED },
          { status: TruceStatus.ACCEPTED, expires_at: { $gt: getCurrentDateTime() } },
        ],
      },
    ],
  });

  if (existingTruce) throw permissionErr();

  const truce = postgres.em.create(Truce, {
    initiator_userid: user.userid,
    recipient_userid: targetUserid,
    status: TruceStatus.REQUESTED,
    created_at: new Date(),
  });

  postgres.em.persist(truce);
  await postgres.em.flush();

  const thread = await findOrCreateThread(0, targetUserid, user.userid);
  thread.truce_id = truce.id;
  thread.trucestate = TruceStatus.REQUESTED;

  const newMessage = postgres.em.create(Message, {
    threadid: thread.threadid,
    userid: user.userid,
    targetid: targetUserid,
    messagetype: "trucerequest",
    userUnread: 0,
    targetUnread: 1,
    subject: `Truce Request from ${user.username}`,
    message,
    updatetime: getCurrentDateTime(),
  } as unknown as MessageData);

  thread.messagecount++;
  thread.lastMessage = newMessage;
  
  postgres.em.persist(thread);
  await postgres.em.flush();

  const recipient = await postgres.em.findOne(User, { userid: targetUserid }, { populate: ["save"] });

  if (recipient?.save) {
    recipient.save.unreadmessages = await countUnreadMessage(targetUserid);
    postgres.em.persist(recipient);
    await postgres.em.flush();
  }

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
