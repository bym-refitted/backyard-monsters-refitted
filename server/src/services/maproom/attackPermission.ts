import type { NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { Save } from "../../database/models/save.model.js";
import { AttackPermission, MapRoomVersion } from "../../enums/MapRoom.js";
import { ATTACK_LEVEL_EXEMPT_FROM, ATTACK_LEVEL_GAP, WORLD_ATTACK_LEVEL_GAP } from "../../config/NeighbourConfig.js";
import { levelTooLowErr } from "../../errors/errors.js";
import { calculateBaseLevel } from "../base/calculateBaseLevel.js";
import { getRetaliationsOwed } from "./attackHistory.js";

type LevelSave = Pick<Save, "points" | "basevalue">;

interface LevelPermission {
  attackerLevel: number;
  defenderLevel: number;
  retaliations: number;
  levelGap?: number;
}

export interface RequireAttackLevel {
  attackerId: number;
  defenderId: number;
  attackerSave: LevelSave;
  defenderSave: LevelSave;
  type: NeighbourAttackType;
  levelGap?: number;
}

/**
 * How many levels below their own a player can still attack on a given map.
 * Map Room 1 and the Inferno hand out neighbours by level, so the limit there
 * is tighter than on the world maps, where anyone nearby is a target.
 *
 * @param {MapRoomVersion} [mapversion] - The map room the attack is on, absent for the Inferno
 * @returns {number} The widest gap that can still be attacked across
 */
export const levelGapFor = (mapversion?: MapRoomVersion): number => {
  const isWorldMap = mapversion === MapRoomVersion.V2 || mapversion === MapRoomVersion.V3;

  return isWorldMap ? WORLD_ATTACK_LEVEL_GAP : ATTACK_LEVEL_GAP;
};

/**
 * What a player's level allows them to do to another, before protection, an
 * attack in progress or a truce are considered.
 *
 * A player cannot attack someone too far below their own level, unless that
 * player attacked them first: they may then hit back once for each attack they
 * took. Attacking someone that far above is allowed, and is what hands the
 * other side those retaliations. Two players who have both reached the
 * exemption level can always attack each other.
 *
 * @param {LevelPermission} options - The two players
 * @param {number} options.attackerLevel - The level of the player who would attack
 * @param {number} options.defenderLevel - The level of the player who would be attacked
 * @param {number} options.retaliations - How many times the first may still hit back at the second
 * @param {number} [options.levelGap] - How many levels down can still be attacked, the neighbour maps' limit by default
 * @returns {AttackPermission} Attackable, higher level, level restriction or vengeance
 */
export const levelPermission = ({ attackerLevel, defenderLevel, retaliations, levelGap = ATTACK_LEVEL_GAP }: LevelPermission): AttackPermission => {
  const bothExempt = attackerLevel >= ATTACK_LEVEL_EXEMPT_FROM && defenderLevel >= ATTACK_LEVEL_EXEMPT_FROM;

  if (bothExempt) return AttackPermission.ATTACKABLE;

  const isDefenderTooLow = attackerLevel - defenderLevel > levelGap;
  const isDefenderFarAbove = defenderLevel - attackerLevel > levelGap;

  if (isDefenderTooLow) {
    return retaliations > 0 ? AttackPermission.VENGEANCE_MODE : AttackPermission.LEVEL_RESTRICTION;
  }

  if (isDefenderFarAbove) return AttackPermission.HIGHER_LEVEL;

  return AttackPermission.ATTACKABLE;
};

/**
 * Refuses an attack the level restriction does not allow, and otherwise says
 * what kind of attack it is so it can be recorded as one. The map already hides
 * the attack button on a restricted neighbour, so the refusal only stops a map
 * that has gone stale - most often a retaliation that has since been used up.
 *
 * @param {RequireAttackLevel} options - The attack being started
 * @param {number} options.attackerId - The player attacking
 * @param {number} options.defenderId - The player being attacked
 * @param {LevelSave} options.attackerSave - The attacker's save on that map
 * @param {LevelSave} options.defenderSave - The defender's save on that map
 * @param {NeighbourAttackType} options.type - Which map the attack is on
 * @param {number} [options.levelGap] - How many levels down can still be attacked, the neighbour maps' limit by default
 * @returns {Promise<AttackPermission>} Attackable, higher level or vengeance
 */
export const requireAttackLevel = async ({ attackerId, defenderId, attackerSave, defenderSave, type, levelGap }: RequireAttackLevel): Promise<AttackPermission> => {
  const retaliations = await getRetaliationsOwed(attackerId, defenderId, type);

  const attackerLevel = calculateBaseLevel(attackerSave.points, attackerSave.basevalue);
  const defenderLevel = calculateBaseLevel(defenderSave.points, defenderSave.basevalue);

  const levels = {
    attackerLevel,
    defenderLevel,
    retaliations,
    levelGap,
  };

  const permission = levelPermission(levels);

  if (permission === AttackPermission.LEVEL_RESTRICTION) throw levelTooLowErr();

  return permission;
};
