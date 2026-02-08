import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { Tribes } from "../../../../enums/Tribes.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { generateBaseId } from "../../../../utils/generateBaseId.js";
import { calculateStructureLevel } from "../../../../services/maproom/v3/calculateStructureLevel.js";
import type { CellData } from "../../../../types/CellData.js";

/**
 * Formats a wild monster cell (stronghold, resource outpost, or defender) for Map Room 3.
 * Mirrors the MR2 wildMonsterCell pattern — deterministic tribe, level, and base ID from coordinates.
 *
 * @param {WorldMapCell} cell - WorldMapCell with x, y, base_type
 * @param {string} worldId - The world UUID for base ID generation
 * @returns Formatted wild monster cell data
 */
export const wildMonsterCell = async (cell: WorldMapCell, worldId: string): Promise<CellData> => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const level = calculateStructureLevel(cellX, cellY, cell.base_type);
  const baseid = generateBaseId(worldId, cellX, cellY);

  // 60% no clover (altitude 5-31), 40% on clovers (altitude 32-49)
  const altitude = 5 + (cellX * 73 + cellY * 31) % 45;

  return {
    uid: 0,
    bid: baseid,
    n: Tribes[tribeIndex],
    tid: 0,
    x: cellX,
    y: cellY,
    i: altitude,
    l: level,
    pl: 0,
    r: 0, // TODO: add range based on the structure level + type
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
    lo: 0,
    fr: 0,
    p: 0,
    t: 0,
    b: cell.base_type,
    rel: EnumBaseRelationship.ENEMY,
  };
};
