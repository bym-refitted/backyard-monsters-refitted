import { BaseType } from "../../enums/Base.js";
import { EnumYardType } from "../../enums/EnumYardType.js";
import { AttackPermission, MapRoomVersion } from "../../enums/MapRoom.js";
import { calculateBaseLevel } from "./calculateBaseLevel.js";
import { getRetaliationsOwed } from "../maproom/attackHistory.js";
import { levelGapFor, levelPermission } from "../maproom/attackPermission.js";
import type { Save } from "../../database/models/save.model.js";

/**
 * Determines whether an attacker is allowed to attack a given base.
 * Returns false if any restriction applies, true otherwise.
 *
 * This is what the client reads as canattack when a player views a base. The
 * same level rule is enforced when an attack is started, in requireAttackLevel.
 *
 * @param {Save} attackerSave - The attacker's save.
 * @param {Save} defenderSave - The defender's save.
 * @param {MapRoomVersion} [mapversion] - The map room version.
 * @returns {Promise<boolean>} Whether the attack is permitted.
 */
export const canAttack = async (attackerSave: Save, defenderSave: Save, mapversion?: MapRoomVersion): Promise<boolean> => {
  const attackerLevel = calculateBaseLevel(attackerSave.points, attackerSave.basevalue);

  /**
   * Tribe resource outpost restriction: high-level players (32+) cannot attack
   * low-level (≤20) MR3 resource outposts.
   */
  if (
    mapversion === MapRoomVersion.V3 &&
    attackerLevel >= 32 &&
    defenderSave.wmid === EnumYardType.RESOURCE &&
    defenderSave.level <= 20
  ) return false;

  const isOwner = attackerSave.saveuserid === defenderSave.saveuserid;

  if (defenderSave.type !== BaseType.MAIN || isOwner) return true;

  /**
   * PvP level restriction: a player cannot attack a main yard too far below
   * their own level, unless its owner attacked them first - they may then hit
   * back once for each attack they took. Two players who have both reached the
   * exemption level can always attack each other.
   */
  const defenderLevel = calculateBaseLevel(defenderSave.points, defenderSave.basevalue);

  const levelGap = levelGapFor(mapversion);

  const levels = { attackerLevel, defenderLevel, retaliations: 0, levelGap };

  const permission = levelPermission(levels);
  if (permission !== AttackPermission.LEVEL_RESTRICTION) return true;

  const retaliations = await getRetaliationsOwed(attackerSave.saveuserid, defenderSave.saveuserid, BaseType.MAIN);
  return retaliations > 0;
};
