import { LockMode, UniqueConstraintViolationException, type FilterQuery } from "@mikro-orm/core";

import type { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceInviteStatus, AllianceInviteType, AllianceMessageType, AllianceRole } from "../../enums/Alliance.js";
import { MAX_ALLIANCE_MEMBERS } from "../../config/AllianceConfig.js";
import { Alliance } from "../../models/alliance.model.js";
import { AllianceInvite } from "../../models/allianceinvite.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { addAllianceMember } from "./membership.js";
import {
  allianceFullErr,
  inviteNotPendingErr,
  invitePendingErr,
  mustLeaveAllianceToAcceptErr,
  permissionErr,
  requestPendingErr,
  userAlreadyInAllianceErr,
} from "../../errors/errors.js";

interface InviteMessage {
  invite_id: number;
  type: AllianceInviteType;
  status: AllianceInviteStatus;
  alliance_name: string;
  alliance_image: number;
  leader_name: string;
  invited_by_name: string;
  user_id: number;
  user_name: string;
  user_pic_square: string | null;
  base_id: string | null;
  update_at_formatted: string;
}

/**
 * Rows the given player should see in their Invites tab.
 *
 * The inbox is one table read from two sides. A pending row belongs to whoever
 * has to answer it, and resolving it hands the row to whoever opened it, so the
 * status change doubles as the "accepted"/"declined" notice. A leader therefore
 * sees incoming requests plus the outcomes of invites they sent; an ordinary
 * player sees incoming invites plus the outcomes of requests they made.
 *
 * @param {User} user - The player whose inbox is being read.
 * @returns {FilterQuery<AllianceInvite>} The visibility clause for that player.
 */
const inboxScope = (user: User): FilterQuery<AllianceInvite> => {
  const asPlayer = {
    user_id: user.userid,
    $or: [
      { type: AllianceInviteType.INVITE, status: AllianceInviteStatus.PENDING },
      { type: AllianceInviteType.REQUEST, status: { $ne: AllianceInviteStatus.PENDING } },
    ],
  };

  const leads = user.alliance_role === AllianceRole.LEADER && user.alliance_id;

  if (!leads) return asPlayer;

  const asLeader = {
    alliance_id: user.alliance_id,
    $or: [
      { type: AllianceInviteType.REQUEST, status: AllianceInviteStatus.PENDING },
      { type: AllianceInviteType.INVITE, status: { $ne: AllianceInviteStatus.PENDING } },
    ],
  };

  return { $or: [asPlayer, asLeader] };
};

/**
 * Formats a timestamp the way the Invites table expects it.
 *
 * @param {Date} date - The timestamp to format.
 * @returns {string} MM/DD/YYYY.
 */
const formatInviteDate = (date: Date): string => {
  const month = `${date.getMonth() + 1}`.padStart(2, "0");
  const day = `${date.getDate()}`.padStart(2, "0");

  return `${month}/${day}/${date.getFullYear()}`;
};

/**
 * Builds the Invites tab payload for a player, resolving the alliance and player
 * named on each row. Both sides are batched rather than fetched per row.
 *
 * @param {User} user - The player whose inbox is being read.
 * @returns {Promise<InviteMessage[]>} Newest first, as the original listed them.
 */
export const getInviteMessages = async (user: User): Promise<InviteMessage[]> => {
  const invites = await postgres.em.find(AllianceInvite, inboxScope(user), { orderBy: { updated_at: "DESC" }});

  if (invites.length === 0) return [];

  const allianceIds = invites.map((invite) => invite.alliance_id);
  const userIds = invites.map((invite) => invite.user_id);

  const [alliances, players] = await Promise.all([
    postgres.em.find(Alliance, { id: { $in: allianceIds } }),
    postgres.em.find(
      User,
      { userid: { $in: userIds } },
      { fields: ["userid", "username", "pic_square", "save.baseid"] }
    ),
  ]);

  const alliancesById = new Map(alliances.map((alliance) => [alliance.id, alliance]));
  const playersById = new Map(players.map((player) => [player.userid, player]));

  const messages: InviteMessage[] = [];

  for (const invite of invites) {
    const alliance = alliancesById.get(invite.alliance_id);
    const player = playersById.get(invite.user_id);

    if (!alliance || !player) continue;

    const message: InviteMessage = {
      invite_id: invite.id,
      type: invite.type,
      status: invite.status,
      alliance_name: alliance.name,
      alliance_image: alliance.image,
      leader_name: alliance.leader_name,
      invited_by_name: alliance.leader_name,
      user_id: player.userid,
      user_name: player.username,
      user_pic_square: player.pic_square ?? null,
      base_id: player.save?.baseid ?? null,
      update_at_formatted: formatInviteDate(invite.updated_at),
    };

    messages.push(message);
  }

  return messages;
};

/**
 * Clears rows from a player's inbox, scoped through the same visibility clause
 * the listing uses, so ids from another inbox match nothing.
 *
 * An unanswered row is declined rather than destroyed: deleting one is a
 * refusal, and the other side is owed the outcome notice. It still leaves the
 * deleter's view, since a resolved row belongs to the counterparty's. Each
 * statement carries its own status predicate, so a row answered mid-request
 * keeps its outcome.
 *
 * @param {User} user - The player clearing their inbox.
 * @param {number[]} inviteIds - The rows they selected.
 * @returns {Promise<number>} How many rows left their inbox.
 */
export const deleteInviteMessages = async (user: User, inviteIds: number[]) => {
  if (inviteIds.length === 0) return 0;

  const scope = { $and: [inboxScope(user), { id: { $in: inviteIds } }] };

  const deleted = await postgres.em.nativeDelete(AllianceInvite, {
    $and: [scope, { status: { $ne: AllianceInviteStatus.PENDING } }],
  });

  const declined = await postgres.em.nativeUpdate(
    AllianceInvite,
    { $and: [scope, { status: AllianceInviteStatus.PENDING }] },
    { status: AllianceInviteStatus.DECLINED, updated_at: new Date() }
  );

  return deleted + declined;
};

/**
 * Drops every pending exchange a player is part of - requests they sent and invites
 * sent to them.
 *
 * Called when their base changes Map Room version, which makes all of them moot:
 * the accept would be refused anyway, and the row would otherwise sit in a leader's
 * Invites tab looking actionable while failing with a message about someone else's
 * map room. Deleted rather than declined, because nobody decided anything.
 *
 * @param {number} userId - The player whose pending rows are being dropped.
 * @returns {Promise<number>} How many rows were removed.
 */
export const clearPendingInvites = async (userId: number): Promise<number> =>
  await postgres.em.nativeDelete(AllianceInvite, {
    user_id: userId,
    status: AllianceInviteStatus.PENDING,
  });

/**
 * Refuses an alliance that has no room left.
 *
 * @param {EntityManager} em - EntityManager to count through, so a caller inside a transaction counts within it.
 * @param {number} allianceId - The alliance being filled.
 */
const checkAllianceSpace = async (em: EntityManager<PostgreSqlDriver>, allianceId: number) => {
  const members = await em.count(User, { alliance_id: allianceId });

  if (members >= MAX_ALLIANCE_MEMBERS) throw allianceFullErr();
};

/**
 * Opens an exchange between an alliance and a player.
 *
 * @param {Alliance} alliance - The alliance being joined or doing the inviting.
 * @param {number} userId - The player being invited, or making the request.
 * @param {AllianceInviteType} type - Which side opened it.
 * @returns {Promise<AllianceInvite>} The pending row.
 */
export const openInvite = async (alliance: Alliance, userId: number, type: AllianceInviteType): Promise<AllianceInvite> => {
  await checkAllianceSpace(postgres.em, alliance.id);

  const invite = new AllianceInvite();
  invite.alliance_id = alliance.id;
  invite.user_id = userId;
  invite.type = type;

  try {
    postgres.em.persist(invite);
    await postgres.em.flush();
  } catch (err) {
    if (!(err instanceof UniqueConstraintViolationException)) throw err;
    throw type === AllianceInviteType.REQUEST ? requestPendingErr() : invitePendingErr();
  }

  return invite;
};

/**
 * Answers a pending exchange.
 *
 * Only the side being asked may answer: an invite is the invited player's to
 * take, a request is the leader's. Accepting joins the player through the
 * membership service inside a transaction, so the row cannot resolve without the
 * membership landing with it.
 *
 * @param {User} user - The player answering.
 * @param {number} inviteId - The row being answered.
 * @param {AllianceInviteStatus} status - Accepted or declined.
 * @returns {Promise<AllianceInvite>} The resolved row.
 */
export const answerInvite = async (user: User, inviteId: number, status: AllianceInviteStatus): Promise<AllianceInvite> => {
  const invite = await postgres.em.findOne(AllianceInvite, { id: inviteId });

  if (!invite) throw permissionErr();

  if (invite.status !== AllianceInviteStatus.PENDING) throw inviteNotPendingErr();

  const isLeader = user.alliance_role === AllianceRole.LEADER;
  const leadsAlliance = isLeader && user.alliance_id === invite.alliance_id;

  const isInvite = invite.type === AllianceInviteType.INVITE;
  const canAnswer = isInvite ? invite.user_id === user.userid : leadsAlliance;

  if (!canAnswer) throw permissionErr();

  if (status === AllianceInviteStatus.DECLINED) {
    invite.status = status;
    await postgres.em.flush();

    return invite;
  }

  const alliance = await postgres.em.findOne(Alliance, { id: invite.alliance_id });

  if (!alliance) throw permissionErr();

  const player = await postgres.em.findOne(User, { userid: invite.user_id });

  if (!player) throw permissionErr();

  const isAnswerer = player.userid === user.userid;

  if (player.alliance_id) {
    throw isAnswerer ? mustLeaveAllianceToAcceptErr() : userAlreadyInAllianceErr();
  }

  // The transaction locks the alliance row to prevent two simultaneous acceptances from both sides
  await postgres.em.transactional(async (em) => {
    await em.findOne(Alliance, { id: alliance.id }, { lockMode: LockMode.PESSIMISTIC_WRITE });
    await checkAllianceSpace(em, alliance.id);

    await em.nativeUpdate(AllianceInvite, { id: invite.id }, { status, updated_at: new Date() });
    await addAllianceMember(player, alliance, AllianceRole.MEMBER, AllianceMessageType.JOINED, em);
  });

  invite.status = status;

  return invite;
};
