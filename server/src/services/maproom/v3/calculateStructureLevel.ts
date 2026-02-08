import { EnumYardType } from "../../../enums/EnumYardType.js";

const structureLevels: Record<number, number[]> = {
  [EnumYardType.STRONGHOLD]: [30, 40, 50],
  [EnumYardType.RESOURCE]: [10, 20, 30, 40, 50],
};

/**
 * Calculates a deterministic structure level based on cell coordinates
 * and the available levels defined in the corresponding data file.
 *
 * @param x - Cell X coordinate
 * @param y - Cell Y coordinate
 * @param type - EnumYardType (STRONGHOLD or RESOURCE)
 * @returns The level for this structure at these coordinates
 */
export const calculateStructureLevel = (x: number, y: number, type: EnumYardType): number => {
  const levels = structureLevels[type];
  if (!levels?.length) return 1;

  const index = Math.abs(x * 73 + y * 31) % levels.length; // TODO: better way to generate pseudo-random but deterministic??
  return levels[index];
};
