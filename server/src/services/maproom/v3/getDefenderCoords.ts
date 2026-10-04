import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getHexNeighborOffsets, type HexCoord } from "./getHexNeighborOffsets.js";

const coordsCache = new Map<string, HexCoord[]>();

export const isDefensiveStructure = (type?: number): boolean =>
  type === EnumYardType.STRONGHOLD ||
  type === EnumYardType.RESOURCE ||
  type === EnumYardType.PLAYER;

/**
 * Returns the 6 surrounding defender coordinates for a cell.
 *
 * @param {number} x - Cell x coordinate
 * @param {number} y - Cell y coordinate
 * @param {EnumYardType} cellType - Cell type. Defaults to PLAYER to return all neighbors when not specified.
 * @returns Array of [x, y] coordinate tuples for defender positions
 */
export const getDefenderCoords = (x: number, y: number, cellType = EnumYardType.PLAYER): HexCoord[] => {
  if (!isDefensiveStructure(cellType)) return [];

  const cacheKey = `${x},${y}`;
  const cached = coordsCache.get(cacheKey);
  if (cached) return cached;

  const offsets = getHexNeighborOffsets(y);
  const coords: HexCoord[] = offsets.map(([dx, dy]): HexCoord => [x + dx, y + dy]);

  coordsCache.set(cacheKey, coords);
  return coords;
};
