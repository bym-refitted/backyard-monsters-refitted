import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceMessageType } from "../../enums/AllianceMessage.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { disconnectAllianceChat } from "../../chat/chatControl.js";
import type { HistoryEntry } from "../../chat/chatProtocol.js";
import { publishAllianceShout } from "../../chat/chatShouts.js";
import { addAllianceMessage, createShoutText } from "./allianceMessages.js";
import { logger } from "../../utils/logger.js";

/**
 * Counts the members of an alliance other than the given user. Callers that
 * need this figure before a removal should pass it into removeAllianceMember
 * rather than letting the service count a second time.
 *
 * @param {User} user - The user to exclude from the count.
 * @param {number} allianceId - The alliance being counted.
 * @returns {Promise<number>} The number of other members.
 */
export const countOtherMembers = async (user: User, allianceId: number): Promise<number> =>
  await postgres.em.count(User, { alliance_id: allianceId, userid: { $ne: user.userid } });

/**
 * Records a membership event in the alliance feed and delivers it live.
 *
 * @param {User} user - The member the shout is about.
 * @param {number} allianceId - The alliance whose feed to write to.
 * @param {AllianceMessageType} type - Which shout to raise.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 */
const emitShout = async (
  user: User,
  allianceId: number,
  type: AllianceMessageType,
  em: EntityManager<PostgreSqlDriver> = postgres.em
) => {
  const draft = { allianceId, userId: user.userid, body: "", type };

  const stored = await addAllianceMessage(draft, em);
  const shoutText = createShoutText(user.username, type);

  const shout: HistoryEntry = {
    userId: user.userid,
    displayName: user.username,
    picSquare: user.pic_square ?? null,
    body: shoutText,
    ts: stored.created_at.getTime(),
    type,
  }

  publishAllianceShout(allianceId, shout);
};

/**
 * Adds a user to an alliance with the given role.
 *
 * The write goes through nativeUpdate so the caller may hand in the EntityManager
 * of an open transaction, whose identity map does not hold the passed user. The
 * in-memory entity is synced to match once the write lands.
 *
 * @param {User} user - The user joining.
 * @param {Alliance} alliance - The alliance being joined.
 * @param {AllianceRole} role - The role to assign the user.
 * @param {AllianceMessageType | null} shout - CREATED for a founder, JOINED for a new member, or null to raise none.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 */
export const addAllianceMember = async (
  user: User,
  alliance: Alliance,
  role: AllianceRole,
  shout: AllianceMessageType | null,
  em: EntityManager<PostgreSqlDriver> = postgres.em
) => {
  const { id } = alliance;

  await em.nativeUpdate(User, { userid: user.userid }, { alliance_id: id, alliance_role: role });

  user.alliance_id = id;
  user.alliance_role = role;

  if (shout) await emitShout(user, id, shout, em);
};

/**
 * Removes a user from their alliance, disbanding it when no one else remains.
 *
 * @param {User} user - The user leaving or being removed.
 * @param {Alliance} alliance - The alliance they belong to.
 * @param {AllianceMessageType} shout - KICKED when removed by a leader, LEFT when they chose to go.
 * @param {number} otherMembers - Members besides this user, when the caller has already counted them.
 * @returns {Promise<boolean>} True if the alliance was disbanded (last member out).
 */
export const removeAllianceMember = async (
  user: User,
  alliance: Alliance,
  shout: AllianceMessageType,
  otherMembers?: number
) => {
  const remaining = otherMembers ?? await countOtherMembers(user, alliance.id);

  user.alliance_id = null;
  user.alliance_role = null;

  const disbanded = remaining === 0;

  if (disbanded) postgres.em.remove(alliance);

  await postgres.em.flush();

  if (!disbanded) {
    await emitShout(user, alliance.id, shout).catch((err) =>
      logger.error(`Alliance shout (${shout}) failed for alliance ${alliance.id}: ${err}`)
    );
  }

  await disconnectAllianceChat(user.userid);

  return disbanded;
};

/**
 * Hands leadership of an alliance to one of its members.
 * 
 * Leader becomes a member, and the member becomes the leader.
 * Alliance ownership is updated to reflect the new leader's userid and username.
 *
 * @param {User} leader - The current leader, stepping down.
 * @param {User} member - The member taking over.
 * @param {Alliance} alliance - The alliance changing hands.
 */
export const promoteAllianceMember = async (leader: User, member: User, alliance: Alliance) => {
  await postgres.em.transactional(async (em) => {
    await em.nativeUpdate(User, { userid: member.userid }, { alliance_role: AllianceRole.LEADER });
    await em.nativeUpdate(User, { userid: leader.userid }, { alliance_role: AllianceRole.MEMBER });

    await em.nativeUpdate(
      Alliance,
      { id: alliance.id },
      { leader_userid: member.userid, leader_name: member.username }
    );
  });

  member.alliance_role = AllianceRole.LEADER;
  leader.alliance_role = AllianceRole.MEMBER;

  alliance.leader_userid = member.userid;
  alliance.leader_name = member.username;

  await emitShout(member, alliance.id, AllianceMessageType.PROMOTED).catch((err) =>
    logger.error(`Alliance shout (promoted) failed for alliance ${alliance.id}: ${err}`)
  );
};
