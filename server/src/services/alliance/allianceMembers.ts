import { BaseType } from "../../enums/Base.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { getLastSeen } from "../maproom/getLastSeen.js";
import { ALLIANCE_MEMBER_FIELDS, toAllianceMember, type AllianceMember } from "./allianceMember.js";

/**
 * Builds the Members tab roster for one alliance.
 *
 * @param {number} allianceId - The alliance whose roster is being read.
 * @returns {Promise<AllianceMember[]>} Members ordered by empire points, highest first.
 */
export const getAllianceMembers = async (allianceId: number): Promise<AllianceMember[]> => {
  const members = await postgres.em.find(
    User,
    { alliance_id: allianceId },
    {
      fields: ALLIANCE_MEMBER_FIELDS,
      orderBy: { userid: "ASC" },
    },
  );

  const lastSeen = await getLastSeen(members.map((member) => member.userid), BaseType.MAIN);
  const now = getCurrentDateTime();

  const roster = members
    .map((member) => toAllianceMember(member, lastSeen, now))
    .filter((member) => member !== null);

  return roster.sort((member, other) => other.points - member.points);
};
