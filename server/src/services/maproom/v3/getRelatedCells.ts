import { EnumYardType } from "../../../enums/EnumYardType";
import { DEFENDER_OFFSETS } from "./getDefenderOutposts";

type Coord = [number, number];
type Cell = { x: number; y: number; t?: number };

const relatedCellsCache = new Map<string, Coord[]>();

const hasDefensiveStructure = (type?: number): boolean =>
  type === EnumYardType.STRONGHOLD;
// Future types: MAIN_YARD, RESOURCE_OUTPOST, etc.

/**
 * Returns coordinates of related cells that should load with the given cell.
 */
export const getRelatedCellPositions = (
  x: number,
  y: number,
  cellType: number | undefined,
  cellsByCoord: Map<string, Cell>
): Coord[] => {
  if (!cellType) return [];

  const cacheKey = `${x},${y},${cellType}`;
  const cached = relatedCellsCache.get(cacheKey);
  if (cached) return cached;

  const related: Coord[] = [];

  // If this cell has defnders
  if (hasDefensiveStructure(cellType)) {
    for (const [dx, dy] of DEFENDER_OFFSETS) related.push([x + dx, y + dy]);
    relatedCellsCache.set(cacheKey, related);
    return related;
  }

  // If this is a defender outpost, link to its parent (and siblings)
  if (cellType === EnumYardType.FORTIFICATION) {
    const parent = DEFENDER_OFFSETS.map(
      ([dx, dy]) => [x + dx, y + dy] as Coord
    ).find(([px, py]) => {
      const parentCell = cellsByCoord.get(`${px},${py}`);
      return parentCell?.t && hasDefensiveStructure(parentCell.t);
    });

    if (parent) {
      const [parentX, parentY] = parent;
      related.push(parent);

      // Include all sibling defender outposts
      for (const [dx, dy] of DEFENDER_OFFSETS)
        related.push([parentX + dx, parentY + dy]);
    }
  }

  relatedCellsCache.set(cacheKey, related);
  return related;
};
