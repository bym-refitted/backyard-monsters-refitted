import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceMessageType } from "../../enums/AllianceMessage.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { disconnectAllianceChat } from "../../chat/chatControl.js";
import { emitShout, type ShoutDraft } from "./allianceMessages.js";
import { logger } from "../../utils/logger.js";

type EntryShout = AllianceMessageType.CREATED | AllianceMessageType.JOINED;
type ExitShout = AllianceMessageType.KICKED | AllianceMessageType.LEFT;

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
 * Adds a user to an alliance with the given role.
 *
 * The write goes through nativeUpdate so the caller may hand in the EntityManager
 * of an open transaction, whose identity map does not hold the passed user. The
 * in-memory entity is synced to match once the write lands.
 *
 * @param {User} user - The user joining.
 * @param {Alliance} alliance - The alliance being joined.
 * @param {AllianceRole} role - The role to assign the user.
 * @param {EntryShout | null} shoutType - CREATED for a founder, JOINED for a new member, or null to raise none.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 */
export const addAllianceMember = async (
  user: User,
  alliance: Alliance,
  role: AllianceRole,
  shoutType: EntryShout | null,
  em: EntityManager<PostgreSqlDriver> = postgres.em
) => {
  const { id } = alliance;

  await em.nativeUpdate(User, { userid: user.userid }, { alliance_id: id, alliance_role: role });

  user.alliance_id = id;
  user.alliance_role = role;

  if (shoutType) await emitShout({ allianceId: id, author: user, type: shoutType, body: "", em });
};

/**
 * Removes a user from their alliance, disbanding it when no one else remains.
 *
 * @param {User} user - The user leaving or being removed.
 * @param {Alliance} alliance - The alliance they belong to.
 * @param {ExitShout} shoutType - KICKED when removed by a leader, LEFT when they chose to go.
 * @param {number} otherMembers - Members besides this user, when the caller has already counted them.
 * @returns {Promise<boolean>} True if the alliance was disbanded (last member out).
 */
export const removeAllianceMember = async (
  user: User,
  alliance: Alliance,
  shoutType: ExitShout,
  otherMembers?: number
) => {
  const remaining = otherMembers ?? await countOtherMembers(user, alliance.id);

  user.alliance_id = null;
  user.alliance_role = null;

  const disbanded = remaining === 0;

  if (disbanded) postgres.em.remove(alliance);

  await postgres.em.flush();

  if (!disbanded) {
    const shout: ShoutDraft = {
      allianceId: alliance.id,
      author: user,
      type: shoutType,
      body: "",
    };

    await emitShout(shout).catch((err) =>
      logger.error(`Alliance shout (${shoutType}) failed for alliance ${alliance.id}: ${err}`)
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

  const shout: ShoutDraft = {
    allianceId: alliance.id,
    author: member,
    type: AllianceMessageType.PROMOTED,
    body: "",
  }

  await emitShout(shout).catch((err) =>
    logger.error(`Alliance shout (promoted) failed for alliance ${alliance.id}: ${err}`)
  );
};
