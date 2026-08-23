import { QueryFlag } from "@mikro-orm/core";

import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { permissionErr } from "../../errors/errors.js";

interface AllianceLookupOptions { withMemberCount?: boolean; }

/**
 * Loads the alliance a user belongs to.
 *
 * member_count is a lazy formula, left unselected by default so the base-load
 * and updatesaved paths that poll through here cost nothing extra. Pass
 * withMemberCount only where the number is displayed: it adds a correlated
 * subquery per row, and reading member_count without it yields undefined
 * rather than a count.
 *
 * @param {User} user - The user whose membership is being resolved.
 * @param {AllianceLookupOptions} options - Which derived fields to populate.
 * @returns {Promise<Alliance | null>} The alliance, or null when the user is unaffiliated.
 */
export const getUserAlliance = async (user: User, options: AllianceLookupOptions = {}): Promise<Alliance | null> => {
  if (!user.alliance_id) return null;

  const findOptions = options.withMemberCount ? { flags: [QueryFlag.INCLUDE_LAZY_FORMULAS] } : undefined;

  return await postgres.em.findOne(Alliance, { id: user.alliance_id }, findOptions);
};

/**
 * Loads the alliance a player is a member of. The guard for every action that
 * only makes sense from inside an alliance; a leader passes it too.
 *
 * @param {User} user - The user whose membership is being resolved.
 * @returns {Promise<Alliance>} The alliance the player is a member of.
 * @throws {ClientSafeError} When the player is not in an alliance.
 */
export const requireAllianceMember = async (user: User): Promise<Alliance> => {
  const alliance = await getUserAlliance(user);

  if (!alliance) throw permissionErr();

  return alliance;
};

/**
 * Loads the alliance a player leads. The guard for every leader-only action,
 * rejecting ordinary members and unaffiliated players alike.
 *
 * @param {User} user - The user whose membership is being resolved.
 * @returns {Promise<Alliance>} The alliance the player leads.
 * @throws {ClientSafeError} When the player does not lead an alliance.
 */
export const requireAllianceLeader = async (user: User): Promise<Alliance> => {
  if (user.alliance_role !== AllianceRole.LEADER) throw permissionErr();

  return await requireAllianceMember(user);
};
