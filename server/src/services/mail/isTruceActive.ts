import { TruceStatus } from "../../enums/TruceStatus.js";
import { Truce } from "../../models/truce.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";

/**
 * Returns true if an accepted, non-expired truce exists between the two users.
 *
 * @param userId - One party in the truce
 * @param targetId - The other party
 */
export const isTruceActive = async (userId: number,targetId: number) => {
  const truce = await postgres.em.findOne(Truce, {
    $and: [
      {
        $or: [
          { initiator_userid: userId, recipient_userid: targetId },
          { initiator_userid: targetId, recipient_userid: userId },
        ],
      },
      {
        status: TruceStatus.ACCEPTED,
        expires_at: { $gt: getCurrentDateTime() },
      },
    ],
  });

  return truce !== null;
};
