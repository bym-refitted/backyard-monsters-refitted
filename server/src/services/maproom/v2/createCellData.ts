import { Loaded } from "@mikro-orm/core";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Context } from "koa";
import { Terrain } from "../../../enums/MapRoom";
import { homeCell } from "../../../controllers/maproom/v2/cells/homeCell";
import { wildMonsterCell } from "../../../controllers/maproom/v2/cells/wildMonsterCell";

/**
 * Constructs the necessary data object of a cell on the world map.
 *
 * @param {Loaded<WorldMapCell, never>} cell - The world map cell to create data for.
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<Object>} - The data object for the cell.
 */
export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  worldID:string,
  ctx: Context
) => {
  if (cell.terrainHeight <= Terrain.WATER3) return { i: cell.terrainHeight };

  // If it's a homebase cell
  if (cell.base_type >= 2) return await homeCell(ctx, cell);

  // Otherwise, return a wild monster cell
  return await wildMonsterCell(cell,worldID);
};
