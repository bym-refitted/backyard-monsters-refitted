import { STRUCTURE_LEVELS } from "../../../config/MapRoom3Config.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";

/**
 * Calculates a deterministic structure level based on cell coordinates
 * and the available levels defined in the corresponding data file.
 *
 * @param {number} x number - Cell X coordinate
 * @param {number} y number - Cell Y coordinate
 * @param {EnumYardType} type - EnumYardType (STRONGHOLD or RESOURCE)
 * @returns The level for this structure at these coordinates
 */
export const calculateStructureLevel = (x: number, y: number, type: EnumYardType): number => {
  const levels = STRUCTURE_LEVELS[type];
  if (!levels?.length) return 1;

  const index = Math.abs(x * 73 + y * 31) % levels.length; // TODO: better way to generate pseudo-random but deterministic??
  return levels[index];
};
