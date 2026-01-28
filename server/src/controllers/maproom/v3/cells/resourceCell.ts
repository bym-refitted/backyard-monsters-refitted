import type { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { EnumYardType } from "../../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { Tribes } from "../../../../enums/Tribes.js";
import type { CellData } from "../../../../types/CellData.js";

/**
 * Formats a resource outpost cell for Map Room 3
 * Wiki: https://backyardmonsters.fandom.com/wiki/Resource_Outpost
 *
 * @param cell - Generated cell with x, y, i (altitude), t (type)
 * @returns Formatted resource outpost cell data
 */
export const resourceCell = async (_: Context, cell: WorldMapCell): Promise<CellData> => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;

  // 60% no clover (altitude 5-31), 40% on clovers (altitude 32-49)
  // Altitude 32-49 maps to clover01.png through clover06.png
  const seed = (cell.x * 73 + cell.y * 31) % 45;
  const altitude = 5 + seed;

  return {
    uid: 0,
    bid: "5678",
    n: Tribes[tribeIndex],
    tid: 0,
    x: cell.x,
    y: cell.y,
    i: altitude,
    l: 30,
    pl: 0,
    r: 4,
    dm: 0,
    lo: 0,
    fr: 0,
    p: 0,
    d: 0,
    t: 0,
    b: EnumYardType.RESOURCE,
    rel: EnumBaseRelationship.ENEMY,
  };
};
