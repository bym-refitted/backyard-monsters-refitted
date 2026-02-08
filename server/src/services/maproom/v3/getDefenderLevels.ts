import { EnumYardType } from "../../../enums/EnumYardType.js";

/** Player yard defenders are fixed regardless of base level. */
const PLAYER_DEFENDER_LEVELS = [5, 5, 10, 10, 15, 20];

/** Resource outpost defender levels by parent structure level. */
const RESOURCE_DEFENDER_LEVELS: Record<number, number[]> = {
  10: [5, 5, 10, 10, 15, 20],
  20: [10, 10, 15, 15, 20, 25],
  30: [20, 20, 25, 25, 30, 35],
  40: [30, 30, 35, 35, 40, 45],
  50: [40, 40, 45, 45, 50, 50],
};

/** Stronghold defender levels by parent structure level. */
const STRONGHOLD_DEFENDER_LEVELS: Record<number, number[]> = {
  30: [20, 20, 25, 25, 30, 35],
  40: [30, 30, 35, 35, 40, 45],
  50: [40, 40, 45, 45, 50, 50],
};

/**
 * Returns the 6 defender levels for a given parent structure type and level.
 * Player yards use fixed levels. Strongholds and resource outposts are level-dependent.
 *
 * @param {EnumYardType} parentType - EnumYardType of the parent structure
 * @param {number} parentLevel - Level of the parent structure (ignored for PLAYER)
 * @returns Array of 6 defender levels, or null if no mapping exists
 */
export const getDefenderLevels = (parentType: EnumYardType, parentLevel?: number) => {
  switch (parentType) {
    case EnumYardType.PLAYER:
      return PLAYER_DEFENDER_LEVELS;

    case EnumYardType.RESOURCE:
      return RESOURCE_DEFENDER_LEVELS[parentLevel];

    case EnumYardType.STRONGHOLD:
      return STRONGHOLD_DEFENDER_LEVELS[parentLevel];

    default:
      return null;
  }
};
