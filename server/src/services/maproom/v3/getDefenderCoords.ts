import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getHexNeighborOffsets } from "./getHexNeighborOffsets.js";

type Coord = [number, number];

const coordsCache = new Map<string, Coord[]>();

export const isDefensiveStructure = (type?: number): boolean =>
  type === EnumYardType.STRONGHOLD ||
  type === EnumYardType.RESOURCE ||
  type === EnumYardType.PLAYER;

/**
 * Returns the 6 surrounding defender coordinates for a cell.
 *
 * @param x - Cell x coordinate
 * @param y - Cell y coordinate
 * @param cellType - Cell type. Defaults to PLAYER to return all neighbors when not specified.
 * @returns Array of [x, y] coordinate tuples for defender positions
 */
export const getDefenderCoords = (x: number, y: number, cellType = EnumYardType.PLAYER): Coord[] => {
  if (!isDefensiveStructure(cellType)) return [];

  const cacheKey = `${x},${y}`;
  const cached = coordsCache.get(cacheKey);
  if (cached) return cached;

  const offsets = getHexNeighborOffsets(y);
  const coords: Coord[] = offsets.map(([dx, dy]): Coord => [x + dx, y + dy]);

  coordsCache.set(cacheKey, coords);
  return coords;
};
