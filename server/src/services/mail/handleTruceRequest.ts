import { TruceStatus } from "../../enums/TruceStatus.js";
import { Truce } from "../../models/truce.model.js";
import type { Thread } from "../../models/thread.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { permissionErr } from "../../errors/errors.js";

/**
 * Creates a truce request from the current user to the message recipient.
 *
 * - Guards against duplicate pending requests and unexpired active truces
 * - Creates a Truce record and links it to the thread
 *
 * @param userid - The authenticated user's ID
 * @param recipientId - The target user's ID
 * @param thread - The mailbox thread to link the truce to
 */
export const handleTruceRequest = async (userid: number, recipientId: number, thread: Thread) => {
  const existingTruce = await postgres.em.findOne(Truce, {
    $and: [
      {
        $or: [
          { initiator_userid: userid, recipient_userid: recipientId },
          { initiator_userid: recipientId, recipient_userid: userid },
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
    initiator_userid: userid,
    recipient_userid: recipientId,
    status: TruceStatus.REQUESTED,
    created_at: new Date(),
  });

  postgres.em.persist(truce);
  await postgres.em.flush();

  thread.truce_id = truce.id;
  thread.trucestate = TruceStatus.REQUESTED;
};
