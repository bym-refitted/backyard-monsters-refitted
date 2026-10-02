import { UniqueConstraintViolationException, type FilterQuery } from "@mikro-orm/core";

import { FriendshipStatus } from "../../enums/Friend.js";
import { MAX_FRIENDS, MAX_PENDING_REQUESTS } from "../../config/FriendConfig.js";
import { Friendship } from "../../database/models/friendship.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import {
  alreadyFriendsErr,
  friendLimitErr,
  friendNotFoundErr,
  friendPendingLimitErr,
  friendRequestNotFoundErr,
  friendRequestPendingErr,
  friendSelfErr,
  friendTargetLimitErr,
  friendUnavailableErr,
} from "../../errors/errors.js";

/**
 * The row between two players, whichever of them sent the request.
 *
 * @param {number} userA - One player.
 * @param {number} userB - The other player.
 * @returns {FilterQuery<Friendship>} Matches the pair in either direction.
 */
export const pairScope = (userA: number, userB: number): FilterQuery<Friendship> => ({
  $or: [
    { requester: userA, recipient: userB },
    { requester: userB, recipient: userA },
  ],
});

/**
 * Every accepted friendship a player is part of.
 *
 * @param {number} userId - The player.
 * @returns {FilterQuery<Friendship>} Accepted rows on either side.
 */
export const acceptedScope = (userId: number): FilterQuery<Friendship> => ({
  status: FriendshipStatus.ACCEPTED,
  $or: [{ requester: userId }, { recipient: userId }],
});

/**
 * Rewrites `user.friendcount` from the table. Recounted rather than adjusted, so
 * a request that fails halfway cannot leave the count drifting.
 *
 * @param {number[]} userIds - The players whose friendships just changed.
 */
const recountFriends = async (userIds: number[]) => {
  for (const userid of userIds) {
    const friendcount = await postgres.em.count(Friendship, acceptedScope(userid));
    await postgres.em.nativeUpdate(User, { userid }, { friendcount });
  }
};

/**
 * Refuses a new friendship when either list is already full.
 *
 * The count is read outside a lock, so two accepts landing together can take a
 * player one or two past the cap. That is harmless and not worth serialising.
 *
 * @param {number} selfId - The player acting, who is told their own list is full.
 * @param {number} otherId - The other player, whose full list is reported generically.
 */
const checkFriendCapacity = async (selfId: number, otherId: number) => {
  const [mine, theirs] = await Promise.all([
    postgres.em.count(Friendship, acceptedScope(selfId)),
    postgres.em.count(Friendship, acceptedScope(otherId)),
  ]);

  if (mine >= MAX_FRIENDS) throw friendLimitErr(MAX_FRIENDS);
  if (theirs >= MAX_FRIENDS) throw friendTargetLimitErr();
};

/**
 * Accepts a pending request. The update is conditional on the row still being
 * pending, so a request withdrawn mid-accept is reported rather than revived.
 *
 * @param {Friendship} request - The pending row.
 * @param {number} selfId - The player accepting.
 */
const acceptRequest = async (request: Friendship, selfId: number) => {
  const requesterId = request.requester.userid;
  const recipientId = request.recipient.userid;
  const otherId = selfId === requesterId ? recipientId : requesterId;

  await checkFriendCapacity(selfId, otherId);

  const accepted = await postgres.em.nativeUpdate(
    Friendship,
    { id: request.id, status: FriendshipStatus.PENDING },
    { status: FriendshipStatus.ACCEPTED, responded_at: new Date() }
  );

  if (!accepted) throw friendRequestNotFoundErr();

  await recountFriends([requesterId, recipientId]);
};

/**
 * Sends a friend request, or accepts one when the other player already asked.
 *
 * A missing, banned or blocking player all get the same refusal, so the sender
 * cannot tell which it was. Blocks are checked in both directions.
 *
 * @param {User} user - The player sending the request.
 * @param {number} targetId - The player being asked.
 * @returns {Promise<FriendshipStatus>} Pending for a new request, accepted when it matched one coming the other way.
 */
export const sendFriendRequest = async (user: User, targetId: number): Promise<FriendshipStatus> => {
  if (targetId === user.userid) throw friendSelfErr();

  const target = await postgres.em.findOne(
    User,
    { userid: targetId },
    { fields: ["userid", "banned", "blockedUsers"] }
  );

  if (!target || target.banned) throw friendUnavailableErr();

  const blocked = user.blockedUsers.includes(targetId) || target.blockedUsers.includes(user.userid);

  if (blocked) throw friendUnavailableErr();

  const existing = await postgres.em.findOne(Friendship, pairScope(user.userid, targetId));

  if (existing?.status === FriendshipStatus.ACCEPTED) throw alreadyFriendsErr();

  if (existing?.requester.userid === user.userid) throw friendRequestPendingErr();

  if (existing) {
    await acceptRequest(existing, user.userid);
    return FriendshipStatus.ACCEPTED;
  }

  const pending = await postgres.em.count(Friendship, {
    requester: user.userid,
    status: FriendshipStatus.PENDING,
  });

  if (pending >= MAX_PENDING_REQUESTS) throw friendPendingLimitErr(MAX_PENDING_REQUESTS);

  await checkFriendCapacity(user.userid, targetId);

  const request = new Friendship();
  request.requester = user;
  request.recipient = postgres.em.getReference(User, target.userid);

  try {
    postgres.em.persist(request);
    await postgres.em.flush();
  } catch (err) {
    if (!(err instanceof UniqueConstraintViolationException)) throw err;
    throw friendRequestPendingErr();
  }

  return FriendshipStatus.PENDING;
};

/**
 * Answers an incoming request. Only the player it was sent to may answer, and
 * declining deletes the row, so the sender is never told.
 *
 * @param {User} user - The player answering.
 * @param {number} requestId - The request being answered.
 * @param {boolean} accept - Whether to accept it.
 */
export const answerFriendRequest = async (user: User, requestId: number, accept: boolean) => {
  const request = await postgres.em.findOne(Friendship, {
    id: requestId,
    recipient: user.userid,
    status: FriendshipStatus.PENDING,
  });

  if (!request) throw friendRequestNotFoundErr();

  if (accept) {
    await acceptRequest(request, user.userid);
    return;
  }

  const declined = await postgres.em.nativeDelete(Friendship, {
    id: request.id,
    status: FriendshipStatus.PENDING,
  });

  if (!declined) throw friendRequestNotFoundErr();
};

/**
 * Deletes whatever row the two players share: unfriends an accepted pair,
 * cancels a request the player sent, or declines one sent to them.
 *
 * @param {User} user - The player removing.
 * @param {number} otherId - The other player.
 */
export const removeFriend = async (user: User, otherId: number) => {
  const removed = await postgres.em.nativeDelete(Friendship, pairScope(user.userid, otherId));

  if (!removed) throw friendNotFoundErr();

  await recountFriends([user.userid, otherId]);
};
