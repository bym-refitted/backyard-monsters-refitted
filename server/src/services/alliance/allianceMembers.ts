import { AllianceRole } from "../../enums/AllianceRole.js";
import { BaseType } from "../../enums/Base.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { calculateEmpirePoints } from "../base/calculateEmpirePoints.js";
import { getLastSeen } from "../maproom/getLastSeen.js";

interface AllianceMemberStatus {
  online: boolean;
  damage_protection: boolean;
}

interface AllianceMember {
  user_id: number;
  display_name: string;
  pic_square: string | null;
  base_id: string | null;
  level: number;
  points: number;
  last_attacker: string;
  is_leader: boolean;
  status: AllianceMemberStatus;
}

const ALLIANCE_MEMBER_FIELDS = [
  "userid",
  "username",
  "pic_square",
  "alliance_role",
  "save.baseid",
  "save.level",
  "save.points",
  "save.basevalue",
  "save.protected",
  "save.lastattackername",
] as const;

/**
 * Builds the Members tab roster for one alliance.
 *
 * @param {number} allianceId - The alliance whose roster is being read.
 * @returns {Promise<AllianceMember[]>} Members ordered by empire points, highest first.
 */
export const getAllianceMembers = async (allianceId: number,): Promise<AllianceMember[]> => {
  const members = await postgres.em.find(
    User,
    { alliance_id: allianceId },
    {
      fields: ALLIANCE_MEMBER_FIELDS,
      orderBy: { userid: "ASC" },
    },
  );

  const memberIds = members.map((member) => member.userid);
  const lastSeen = await getLastSeen(memberIds, BaseType.MAIN);

  const now = getCurrentDateTime();

  const roster: AllianceMember[] = [];

  for (const member of members) {
    const save = member.save;

    // Should never happen
    if (!save) continue;

    const status: AllianceMemberStatus = {
      online: lastSeen.has(member.userid),
      damage_protection: save.protected > now,
    };

    const empirePoints = calculateEmpirePoints(save.points, save.basevalue);

    const allianceMember: AllianceMember = {
      user_id: member.userid,
      display_name: member.username,
      pic_square: member.pic_square ?? null,
      base_id: save.baseid,
      level: save.level,
      points: empirePoints,
      last_attacker: save.lastattackername ?? "",
      is_leader: member.alliance_role === AllianceRole.LEADER,
      status,
    };

    roster.push(allianceMember);
  }

  return roster.sort((member, other) => other.points - member.points);
};
