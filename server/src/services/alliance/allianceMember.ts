import type { Loaded } from "@mikro-orm/core";

import { AllianceRole } from "../../enums/Alliance.js";
import { BaseType } from "../../enums/Base.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { calculateEmpirePoints } from "../base/calculateEmpirePoints.js";
import { calculateBaseLevel } from "../base/calculateBaseLevel.js";
import { getLastSeen } from "../maproom/getLastSeen.js";

export interface AllianceDetails {
  online: number;
  avgLevel: number;
}

interface AllianceMemberStatus {
  online: boolean;
  damage_protection: boolean;
}

export interface AllianceMember {
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

export type LoadedMember = Loaded<User, never, (typeof ALLIANCE_MEMBER_FIELDS)[number]>;

export const ALLIANCE_MEMBER_FIELDS = [
  "userid",
  "username",
  "pic_square",
  "alliance_role",
  "save.baseid",
  "save.points",
  "save.basevalue",
  "save.protected",
  "save.lastattackername",
] as const;

const MEMBER_SUMMARY_FIELDS = [
  "userid",
  "save.type",
  "save.points",
  "save.basevalue",
] as const;

/**
 * Describes one player for the Members and Suggested tables.
 *
 * @param {LoadedMember} member - The user to describe, read with ALLIANCE_MEMBER_FIELDS.
 * @param {Map<number, number>} lastSeen - Who is currently online, by user id.
 * @param {number} now - Current epoch seconds, for the damage protection window.
 * @returns {AllianceMember | null} The player, or null when they have no main base.
 */
export const toAllianceMember = (
  member: LoadedMember, 
  lastSeen: Map<number, number>, 
  now: number
): AllianceMember | null => {
  const { userid, save, alliance_role, username, pic_square } = member;

  // Should never happen
  if (!save) return null;

  const status = {
    online: lastSeen.has(userid),
    damage_protection: save.protected > now,
  };

  const isLeader = alliance_role === AllianceRole.LEADER;

  return {
    user_id: userid,
    display_name: username,
    pic_square: pic_square ?? null,
    base_id: save.baseid,
    level: calculateBaseLevel(save.points, save.basevalue),
    points: calculateEmpirePoints(save.points, save.basevalue),
    last_attacker: save.lastattackername ?? "",
    is_leader: isLeader,
    status,
  };
};

/**
 * The member figures the My Alliance tab prints beside an alliance's name.
 *
 * @param {number} allianceId - The alliance to summarise.
 * @returns {Promise<AllianceDetails>} Members currently online, and the rounded average level.
 */
export const getAllianceDetails = async (allianceId: number): Promise<AllianceDetails> => {
  const members = await postgres.em.find(User,
    { alliance_id: allianceId },
    { fields: MEMBER_SUMMARY_FIELDS }
  );

  if (members.length === 0) return { online: 0, avgLevel: 0 };

  const lastSeen = await getLastSeen(members.map(({ userid }) => userid), BaseType.MAIN);

  const mainYards = members
    .map(({ save }) => save)
    .filter((save) => save?.type === BaseType.MAIN);

  const levels = mainYards.reduce(
    (sum, save) => sum + calculateBaseLevel(save!.points, save!.basevalue),
    0
  );

  const average = mainYards.length === 0 ? 0 : Math.round(levels / mainYards.length);

  return { online: lastSeen.size, avgLevel: average };
};
