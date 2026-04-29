import { TruceStatus } from "../../enums/TruceStatus.js";
import { Truce } from "../../models/truce.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";

export interface TruceInfo {
  trucestate: TruceStatus;
  expires_at?: number;
}

export type Truces = Map<number, TruceInfo>;

/**
 * Batch-loads active or pending truces between the current user and a list of cell owners.
 *
 * Returns a map keyed by the other party's userid for O(1) lookup per cell.
 *
 * @param currentUserId - The authenticated user's ID
 * @param ownerIds - The cell owner userids to check against
 */
export const getTruces = async (currentUserId: number | undefined, ownerIds: number[]): Promise<Truces> => {
  if (currentUserId === undefined || !ownerIds.length) return new Map();

  const activeTruces: Truces = new Map();

  const now = getCurrentDateTime();

  const truces = await postgres.em.find(Truce, {
    $and: [
      {
        $or: [
          { initiator_userid: currentUserId, recipient_userid: { $in: ownerIds } },
          { recipient_userid: currentUserId, initiator_userid: { $in: ownerIds } },
        ],
      },
      {
        $or: [
          { status: TruceStatus.REQUESTED },
          { status: TruceStatus.ACCEPTED, expires_at: { $gt: now } },
        ],
      },
    ],
  });

  for (const truce of truces) {
    const isInitiator = truce.initiator_userid === currentUserId;
    const targetUserId = isInitiator ? truce.recipient_userid : truce.initiator_userid;

    activeTruces.set(targetUserId, { trucestate: truce.status, expires_at: truce.expires_at });
  }

  return activeTruces;
};
