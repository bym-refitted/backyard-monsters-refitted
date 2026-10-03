import type { Loaded } from "@mikro-orm/core";

import { GIFT_COOLDOWN_SECONDS, MAX_PENDING_GIFTS } from "../../config/GiftConfig.js";
import { Gift } from "../../database/models/gift.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { getFriendIds } from "../friends/friendList.js";
import {
  giftCooldownErr,
  giftInboxFullErr,
  giftNotFriendsErr,
  giftSelfErr,
} from "../../errors/errors.js";

export type GiftEntry = [number, string, number, string];

type GiftRow = Loaded<Gift, never, (typeof GIFT_FIELDS)[number]>;

const GIFT_FIELDS = [
  "id",
  "sender.userid",
  "sender.username",
  "sender.pic_square",
  "recipient.userid",
  "recipient.username",
  "recipient.pic_square",
] as const;

/**
 * Shapes one row the way the client's gift popup expects it.
 *
 * @param {GiftRow} gift - The gift being described.
 * @param {User} player - Whose side of it to show: the other player is named.
 * @returns {GiftEntry} The four element entry.
 */
const toGiftEntry = (gift: GiftRow, player: User): GiftEntry => {
  const isSender = gift.sender.userid === player.userid;
  const other = isSender ? gift.recipient : gift.sender;

  return [gift.id, other.username, other.userid, other.pic_square ?? ""];
};

/**
 * Sends a mystery sack to a friend.
 *
 * Refuses anyone who is not an accepted friend, a second gift inside the cooldown,
 * and a recipient whose unclaimed pile is already full.
 *
 * @param {User} user - The sender.
 * @param {number} recipientId - The friend being gifted.
 * @returns {Promise<Gift>} The gift that is now waiting for them.
 */
export const sendGift = async (user: User, recipientId: number): Promise<Gift> => {
  if (recipientId === user.userid) throw giftSelfErr();

  const friendIds = await getFriendIds(user.userid);

  if (!friendIds.has(recipientId)) throw giftNotFriendsErr();

  const cooldownStart = new Date(Date.now() - GIFT_COOLDOWN_SECONDS * 1000);

  const [recent, pending] = await Promise.all([
    postgres.em.count(Gift, {
      sender: user.userid,
      recipient: recipientId,
      created_at: { $gt: cooldownStart },
    }),

    postgres.em.count(Gift, { recipient: recipientId, claimed_at: null }),
  ]);

  if (recent > 0) throw giftCooldownErr();

  if (pending >= MAX_PENDING_GIFTS) throw giftInboxFullErr();

  const gift = new Gift();
  gift.sender = user;
  gift.recipient = postgres.em.getReference(User, recipientId);

  postgres.em.persist(gift);
  await postgres.em.flush();

  return gift;
};

/**
 * The gifts waiting for a player, as the base load payload carries them.
 *
 * @param {User} user - The player loading their base.
 * @returns {Promise<GiftEntry[]>} Unclaimed gifts, oldest first.
 */
export const getPendingGifts = async (user: User): Promise<GiftEntry[]> => {
  const where = { recipient: user.userid, claimed_at: null };

  const options = { fields: GIFT_FIELDS, orderBy: { created_at: "ASC" }, limit: MAX_PENDING_GIFTS };

  const gifts = await postgres.em.find(Gift, where, options);

  return gifts.map((gift) => toGiftEntry(gift, user));
};

/**
 * The gifts a player sent that have since been collected and not yet reported,
 * which is what earns them the experience reward.
 *
 * @param {User} user - The sender loading their base.
 * @returns {Promise<GiftEntry[]>} Collected gifts awaiting acknowledgement.
 */
export const getAcceptedGifts = async (user: User): Promise<GiftEntry[]> => {
  const where = { sender: user.userid, claimed_at: { $ne: null }, acknowledged_at: null };
  
  const options = { fields: GIFT_FIELDS, orderBy: { claimed_at: "ASC" }, limit: MAX_PENDING_GIFTS };

  const gifts = await postgres.em.find(Gift, where, options);

  return gifts.map((gift) => toGiftEntry(gift, user));
};

/**
 * Records the gifts a player collected, from the ids their save reports.
 *
 * Scoped to that player's own unclaimed gifts, so a replayed or invented id
 * marks nothing. The update is the only thing that credits a gift, so a repeated
 * save cannot collect the same sack twice.
 *
 * @param {User} user - The player who collected them.
 * @param {number[]} giftIds - The ids their client reported.
 * @returns {Promise<number>} How many were newly marked as collected.
 */
export const claimGifts = async (user: User, giftIds: number[]): Promise<number> => {
  if (!giftIds.length) return 0;

  const where = { id: { $in: giftIds }, recipient: user.userid, claimed_at: null };

  return await postgres.em.nativeUpdate(Gift, where, { claimed_at: new Date() });
};

/**
 * Marks collected gifts as reported back to their sender, so the thank you popup
 * is shown once.
 *
 * @param {User} user - The sender whose client has shown them.
 * @param {number[]} giftIds - The ids their client reported.
 * @returns {Promise<number>} How many were newly acknowledged.
 */
export const acknowledgeGifts = async (user: User, giftIds: number[]): Promise<number> => {
  if (!giftIds.length) return 0;

  const where = {
    id: { $in: giftIds },
    sender: user.userid,
    claimed_at: { $ne: null },
    acknowledged_at: null,
  };

  return await postgres.em.nativeUpdate(Gift, where, { acknowledged_at: new Date() });
};

/**
 * When each friend may be gifted again, for the launcher and website to label
 * their buttons with.
 *
 * @param {number} userId - The sender.
 * @param {number[]} friendIds - The friends being listed.
 * @returns {Promise<Map<number, number>>} Friend id to the epoch seconds their cooldown ends.
 */
export const getGiftCooldowns = async (userId: number, friendIds: number[]) => {
  if (!friendIds.length) return new Map();

  const cooldownStart = new Date(Date.now() - GIFT_COOLDOWN_SECONDS * 1000);

  const where = { sender: userId, recipient: { $in: friendIds }, created_at: { $gt: cooldownStart } };

  const recent = await postgres.em.find(Gift, where, { fields: ["recipient", "created_at"] });

  const readyAt = new Map<number, number>();

  for (const gift of recent) {
    const ready = Math.floor(gift.created_at.getTime() / 1000) + GIFT_COOLDOWN_SECONDS;
    const current = readyAt.get(gift.recipient.userid) ?? 0;

    if (ready > current) readyAt.set(gift.recipient.userid, ready);
  }

  return readyAt;
};
