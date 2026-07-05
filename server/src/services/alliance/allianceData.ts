import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

interface AllianceData {
  alliance_id: number;
  name: string;
  image: number;
  is_leader: boolean;
  relationships: Record<string, number>;
}

/**
 * Builds the base-load alliancedata payload for a user, or null when they are
 * unaffiliated.
 *
 * @param {User} user - The base owner being loaded.
 * @returns {Promise<AllianceData | null>} The payload, or null if the user has no alliance.
 */
export const getAllianceData = async (user: User): Promise<AllianceData | null> => {
  if (!user.alliance_id) return null;

  const alliance = await postgres.em.findOne(Alliance, { id: user.alliance_id });

  if (!alliance) return null;

  return {
    alliance_id: alliance.id,
    name: alliance.name,
    image: alliance.image,
    is_leader: user.alliance_role === AllianceRole.LEADER,
    relationships: {},
  };
};
