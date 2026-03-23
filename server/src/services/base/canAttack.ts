import { BaseType } from "../../enums/Base.js";
import { EnumYardType } from "../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import { calculateBaseLevel } from "./calculateBaseLevel.js";
import type { Save } from "../../models/save.model.js";

/**
 * Determines whether an attacker is allowed to attack a given base.
 * Returns false if any restriction applies, true otherwise.
 *
 * @param {Save} attackerSave - The attacker's save.
 * @param {Save} defenderSave - The defender's save.
 * @param {MapRoomVersion} [mapversion] - The map room version.
 * @returns {boolean} Whether the attack is permitted.
 */
export const canAttack = (attackerSave: Save, defenderSave: Save, mapversion?: MapRoomVersion): boolean => {
  const isOwner = defenderSave.type !== BaseType.INFERNO && attackerSave.saveuserid === defenderSave.saveuserid;
  const attackerLevel = calculateBaseLevel(attackerSave.points, attackerSave.basevalue);

  /**
   * Tribe resource outpost restriction: high-level players (30+) cannot attack
   * low-level (≤20) MR3 resource outposts.
   */
  if (
    mapversion === MapRoomVersion.V3 &&
    attackerLevel >= 30 &&
    defenderSave.wmid === EnumYardType.RESOURCE &&
    defenderSave.level <= 20
  ) return false;

  /**
   * PvP level restriction: attackers cannot attack player main yards more than
   * 12 levels below them. Both players in the level 40–80 safe zone
   * can always attack each other. Although the max level is 56, we use 80 as a client-safe upper bound.
   */
  if (defenderSave.type === BaseType.MAIN && !isOwner) {
    const defenderLevel = calculateBaseLevel(defenderSave.points, defenderSave.basevalue);
    const inSafeZone = attackerLevel >= 40 && attackerLevel <= 80 && defenderLevel >= 40 && defenderLevel <= 80;

    if (attackerLevel - defenderLevel >= 12 && !inSafeZone) return false;
  }

  return true;
};
