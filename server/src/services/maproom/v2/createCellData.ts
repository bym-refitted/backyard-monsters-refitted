import { Loaded } from "@mikro-orm/core";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Context } from "koa";
import { Terrain } from "../../../enums/MapRoom";
import { homeCell } from "../../../controllers/maproom/v2/cells/homeCell";
import { Tribes } from "../../../enums/Tribes";

/**
 * Constructs the necessary data object of a cell on the world map.
 *
 * @param {Loaded<WorldMapCell, never>} cell - The world map cell to create data for.
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<Object>} - The data object for the cell.
 */
export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  ctx: Context
) => {
  if (cell.terrainHeight <= Terrain.WATER3) return { i: cell.terrainHeight };

  // If it's a homebase cell or outpost
  if (cell.base_type >= 2) return await homeCell(ctx, cell);

  const tribeIndex = (cell.x + cell.y) % Tribes.length;
  let baseId = 1000000 + cell.y + cell.x * 1000;

  return {
    uid: baseId,
    b: 1,
    i: cell.terrainHeight,
    bid: baseId,
    n: Tribes[tribeIndex],
    l: 40,
    dm: 0,
    d: 0,
  };
};
