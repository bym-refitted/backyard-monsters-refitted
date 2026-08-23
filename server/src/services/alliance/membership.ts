import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

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
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 */
export const addAllianceMember = async (
  user: User,
  alliance: Alliance,
  role: AllianceRole,
  em: EntityManager<PostgreSqlDriver> = postgres.em
) => {
  const { id } = alliance;

  await em.nativeUpdate(User, { userid: user.userid }, { alliance_id: id, alliance_role: role });

  user.alliance_id = id;
  user.alliance_role = role;
};

/**
 * Removes a user from their alliance, disbanding it when no one else remains.
 *
 * @param {User} user - The user leaving or being removed.
 * @param {Alliance} alliance - The alliance they belong to.
 * @param {number} otherMembers - Members besides this user, when the caller has already counted them.
 * @returns {Promise<boolean>} True if the alliance was disbanded (last member out).
 */
export const removeAllianceMember = async (user: User, alliance: Alliance, otherMembers?: number) => {
  const remaining = otherMembers ?? await countOtherMembers(user, alliance.id);

  user.alliance_id = null;
  user.alliance_role = null;

  const disbanded = remaining === 0;

  if (disbanded) postgres.em.remove(alliance);

  await postgres.em.flush();
  return disbanded;
};
