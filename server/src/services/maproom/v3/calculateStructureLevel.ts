import { EnumYardType } from "../../../enums/EnumYardType.js";
import { strongholds } from "../../../data/tribes/v3/strongholds.js";
import { resources } from "../../../data/tribes/v3/resources.js";
import { defenders } from "../../../data/tribes/v3/defenders.js";

const dataByType: Record<number, Record<number, Record<string, any>>> = {
  [EnumYardType.STRONGHOLD]: strongholds,
  [EnumYardType.RESOURCE]: resources,
  [EnumYardType.FORTIFICATION]: defenders,
};

/**
 * Pre-computed sorted level arrays per structure type.
 */
const levelsByType: Record<number, number[]> = {};

for (const [type, data] of Object.entries(dataByType)) {
  levelsByType[Number(type)] = Object.keys(data)
    .map(Number)
    .sort((a, b) => a - b);
}

/**
 * Calculates a deterministic structure level based on cell coordinates
 * and the available levels defined in the corresponding data file.
 *
 * @param x - Cell X coordinate
 * @param y - Cell Y coordinate
 * @param type - EnumYardType (STRONGHOLD, RESOURCE, or FORTIFICATION)
 * @returns The level for this structure at these coordinates
 */
export const calculateStructureLevel = (x: number, y: number, type: EnumYardType) => {
  const levels = levelsByType[type];
  if (!levels?.length) return 1;

  const index = Math.abs(x * 73 + y * 31) % levels.length;
  return levels[index];
};
