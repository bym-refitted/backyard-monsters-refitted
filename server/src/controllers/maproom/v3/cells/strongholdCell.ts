import { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";

/**
 * Formats a stronghold cell for Map Room 3
 *
 * @param cell - Generated cell with x, y, i (altitude), t (type)
 * @returns Formatted stronghold cell data
 */
export const strongholdCell = async (
  ctx: Context,
  cell: WorldMapCell
): Promise<CellData> => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;

  return {
    uid: 0,
    bid: 1234,
    n: Tribes[tribeIndex],
    tid: 0,
    x: cell.x,
    y: cell.y,
    i: 50, // value 50 places strongholds above terrain
    l: 50,
    pl: 0,
    r: 0,
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
