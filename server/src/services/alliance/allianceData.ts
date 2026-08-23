import { AllianceRole } from "../../enums/AllianceRole.js";
import { User } from "../../models/user.model.js";
import { getUserAlliance } from "./allianceAccess.js";

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
  const alliance = await getUserAlliance(user);

  if (!alliance) return null;

  return {
    alliance_id: alliance.id,
    name: alliance.name,
    image: alliance.image,
    is_leader: user.alliance_role === AllianceRole.LEADER,
    relationships: {},
  };
};
