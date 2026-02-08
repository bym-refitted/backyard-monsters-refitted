import { DEFENDER_LEVELS } from "../../../config/MapRoom3Config.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";

/**
 * Returns the 6 defender levels for a given parent structure type and level.
 * Player yards use fixed levels (pass 0 for parentLevel). Strongholds and resources are level-dependent.
 *
 * @param {EnumYardType} parentType - EnumYardType of the parent structure
 * @param {number} parentLevel - Level of the parent structure (0 for PLAYER)
 * @returns Array of 6 defender levels, or undefined if no mapping exists
 */
export const getDefenderLevels = (parentType: EnumYardType, parentLevel: number = 0): number[] | undefined => {
  return DEFENDER_LEVELS[parentType]?.[parentLevel];
};
