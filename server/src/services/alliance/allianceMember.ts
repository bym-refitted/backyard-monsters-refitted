import type { Loaded } from "@mikro-orm/core";

import { AllianceRole } from "../../enums/AllianceRole.js";
import { User } from "../../models/user.model.js";
import { calculateEmpirePoints } from "../base/calculateEmpirePoints.js";

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
  "save.level",
  "save.points",
  "save.basevalue",
  "save.protected",
  "save.lastattackername",
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
    level: save.level,
    points: calculateEmpirePoints(save.points, save.basevalue),
    last_attacker: save.lastattackername ?? "",
    is_leader: isLeader,
    status,
  };
};
