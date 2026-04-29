import { TruceStatus } from "../../enums/TruceStatus.js";
import { Truce } from "../../models/truce.model.js";
import type { Thread } from "../../models/thread.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { mailboxErr, permissionErr } from "../../errors/errors.js";
import { TRUCE_DURATION } from "../../controllers/mail/requestTruce.js";

type TruceResponse = TruceStatus.ACCEPTED | TruceStatus.REJECTED;

/**
 * Accepts or rejects a pending truce request on behalf of the recipient.
 *
 * - Validates the thread has a linked truce
 * - Validates the truce is still in REQUESTED state
 * - Validates the caller is the truce recipient (not the initiator)
 * - On accept: sets status to ACCEPTED and calculates expiry
 * - On reject: sets status to REJECTED
 *
 * @param userid - The authenticated user's ID
 * @param thread - The mailbox thread linked to the truce
 * @param status - TruceStatus.ACCEPTED or TruceStatus.REJECTED
 */
export const handleTruceResponse = async (userid: number, thread: Thread, status: TruceResponse) => {
  if (!thread.truce_id) throw mailboxErr();

  const truce = await postgres.em.findOne(Truce, { id: thread.truce_id });

  if (!truce || truce.status !== TruceStatus.REQUESTED) throw mailboxErr();
  
  if (truce.recipient_userid !== userid) throw permissionErr();

  truce.status = status;
  thread.trucestate = status;

  if (status === TruceStatus.ACCEPTED) {
    truce.expires_at = getCurrentDateTime() + TRUCE_DURATION;
  }

  postgres.em.persist(truce);
};
