import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

/**
 * Adds a user to an alliance with the given role and resyncs member_count.
 *
 * @param {User} user - The user joining.
 * @param {Alliance} alliance - The alliance being joined.
 * @param {AllianceRole} role - The role to assign the user.
 */
export const addAllianceMember = async (user: User, alliance: Alliance, role: AllianceRole) => {
  const { id } = alliance;
  
  user.alliance_id = id;
  user.alliance_role = role;

  const members = await postgres.em.count(User, { alliance_id: id, userid: { $ne: user.userid } });

  alliance.member_count = members + 1;
  await postgres.em.flush();
};

/**
 * Removes a user from their alliance. Clears their membership and then either
 * disbands the alliance when no one else remains, or resyncs member_count to
 * the true remaining total.
 *
 * @param {User} user - The user leaving or being removed.
 * @param {Alliance} alliance - The alliance they belong to.
 * @returns {Promise<boolean>} True if the alliance was disbanded (last member out).
 */
export const removeAllianceMember = async (user: User, alliance: Alliance) => {
  const { id } = alliance;

  const members = await postgres.em.count(User, { alliance_id: id, userid: { $ne: user.userid } });

  user.alliance_id = null;
  user.alliance_role = null;

  const disbanded = members === 0;

  if (disbanded) postgres.em.remove(alliance);
  else alliance.member_count = members;

  await postgres.em.flush();
  return disbanded;
};
