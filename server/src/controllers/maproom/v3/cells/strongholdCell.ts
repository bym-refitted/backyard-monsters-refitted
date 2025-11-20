import { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";

/**
 * Formats a stronghold cell for Map Room 3
 * Wiki: https://backyardmonsters.fandom.com/wiki/Stronghold
 *
 * @param cell - Generated cell with x, y, i (altitude), t (type)
 * @returns Formatted stronghold cell data
 */
export const strongholdCell = async (
  ctx: Context,
  cell: WorldMapCell
): Promise<CellData> => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;

  // 60% no clover (altitude 5-31), 40% on clovers (altitude 32-49)
  // Altitude 32-49 maps to clover01.png through clover06.png
  const seed = (cell.x * 73 + cell.y * 31) % 45;
  const altitude = 5 + seed;

  return {
    uid: 0,
    bid: 1234,
    n: Tribes[tribeIndex],
    tid: 0,
    x: cell.x,
    y: cell.y,
    i: altitude,
    l: 50,
    pl: 0,
    r: 20,
    dm: 0,
    lo: 0,
    fr: 0,
    p: 0,
    d: 0,
    t: 0,
    b: EnumYardType.STRONGHOLD,
    rel: EnumBaseRelationship.ENEMY,
  };
};
