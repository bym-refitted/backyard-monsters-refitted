import { AllianceRole } from "../../enums/AllianceRole.js";
import { User } from "../../models/user.model.js";
import { getUserAlliance } from "./allianceAccess.js";
import { getAllianceRelationships, type Relationship } from "./relationships.js";

interface AllianceData {
  alliance_id: number;
  name: string;
  image: number;
  is_leader: boolean;
  relationships: Relationship;
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

  const { id, name, image } = alliance;

  const isLeader = user.alliance_role === AllianceRole.LEADER;
  const relationships = await getAllianceRelationships(id);

  return { alliance_id: id, name, image, is_leader: isLeader, relationships };
};
