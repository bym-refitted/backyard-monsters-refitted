import { AllianceRole } from "../../enums/Alliance.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { permissionErr } from "../../errors/errors.js";

interface AllianceLookupOptions { withStats?: boolean; }

/**
 * Loads the alliance a user belongs to.
 *
 * Standing - member count, empire points, average level, both ranks - lives in the
 * bym.alliance_stats view and is left unjoined by default, so the base-load and
 * updatesaved paths that poll through here cost nothing extra.
 *
 * Pass withStats wherever those numbers are displayed. Forgetting it is not caught by
 * the compiler: an unpopulated relation is an empty reference rather than undefined, so
 * reading through it yields undefined for every field and the response quietly loses
 * them rather than failing.
 *
 * @param {User} user - The user whose membership is being resolved.
 * @param {AllianceLookupOptions} options - Whether to join the alliance's standing.
 * @returns {Promise<Alliance | null>} The alliance, or null when the user is unaffiliated.
 */
export const getUserAlliance = async (user: User, options: AllianceLookupOptions = {}): Promise<Alliance | null> => {
  if (!user.alliance_id) return null;

  const where = { id: user.alliance_id };

  if (options.withStats) return await postgres.em.findOne(Alliance, where, { populate: ["stats"] });

  return await postgres.em.findOne(Alliance, where);
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
