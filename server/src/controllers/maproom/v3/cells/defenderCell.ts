import { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";

/**
 * Formats a fortification (defender) cell for Map Room 3
 *
 * @param cell - Generated cell with x, y, i (altitude), t (type)
 * @returns Formatted fortification cell data
 */
export const defenderCell = async (
  ctx: Context,
  cell: WorldMapCell
): Promise<CellData> => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;

  // Generate unique tid (tribe ID) based on exact coordinates
  // Each defender gets a unique tid so they never fortify structures (structures have tid: 0)
  // Format: x * 1000 + y ensures uniqueness and never matches structure tid of 0
  const tid = cell.x * 1000 + cell.y;

  // 60% no clover (altitude 5-31), 40% on clovers (altitude 32-49)
  // Altitude 32-49 maps to clover01.png through clover06.png
  const altitude = 5 + (cell.x * 73 + cell.y * 31) % 45;

  return {
    uid: 0,
    bid: "1234",
    n: Tribes[tribeIndex],
    tid,
    x: cell.x,
    y: cell.y,
    i: altitude,
    l: 50,
    pl: 0,
    r: 0,
    dm: 0,
    lo: 0,
    fr: 0,
    p: 0,
    d: 0,
    t: 0,
    b: EnumYardType.FORTIFICATION,
    rel: EnumBaseRelationship.ENEMY,
  };
};
