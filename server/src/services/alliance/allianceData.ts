import { AllianceRole } from "../../enums/Alliance.js";
import { Alliance } from "../../database/models/alliance.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { getUserAlliance } from "./allianceAccess.js";
import { getAllianceRelationships, type Relationship } from "./relationships.js";

interface AllianceData {
  alliance_id: number;
  name: string;
  image: number;
  is_leader: boolean;
  relationships: Relationship;
}

export interface AllianceRosterEntry {
  alliance_id: number;
  name: string;
  image: number;
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

/**
 * Builds the map room alliancedata roster - one entry per alliance visible in a
 * chunk of cells, rather than the single object above describing the viewer's own.
 *
 * @param {number[]} allianceIds - Distinct alliance ids referenced by the chunk.
 * @returns {Promise<AllianceRosterEntry[]>} One entry per alliance that exists.
 */
export const getAllianceRoster = async (allianceIds: number[]): Promise<AllianceRosterEntry[]> => {
  if (!allianceIds.length) return [];

  const alliances = await postgres.em.find(
    Alliance,
    { id: { $in: allianceIds } },
    { fields: ["id", "name", "image"] }
  );

  return alliances.map(({ id, name, image }) => ({
    alliance_id: id,
    name,
    image,
    relationships: {},
  }));
};
