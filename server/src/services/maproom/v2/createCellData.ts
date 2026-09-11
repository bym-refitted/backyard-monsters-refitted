import type { Loaded } from "@mikro-orm/core";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import type { Context } from "koa";
import { Terrain } from "../../../enums/MapRoom.js";
import { userCell, type UserCellFields, type UserCellOwner } from "../../../controllers/maproom/v2/cells/userCell.js";
import { wildMonsterCell, type WildMonsterCellFields } from "../../../controllers/maproom/v2/cells/wildMonsterCell.js";

export type MapCell = Loaded<WorldMapCell, "save", UserCellFields | WildMonsterCellFields>;

/**
 * Constructs the necessary data object of a cell on the world map.
 *
 * @param {MapCell} cell - The world map cell, with every save field its handlers read.
 * @param {string} worldid - The world ID.
 * @param {Context} ctx - The Koa context object.
 * @param {Map<number, UserCellOwner>} cellOwners - Pre-loaded map of user IDs to cell owners (optional for in-memory cells).
 * @returns {Promise<Object>} - The data object for the cell.
 */
export const createCellData = async (
  cell: MapCell,
  worldid: string,
  ctx: Context,
  cellOwners: Map<number, UserCellOwner> = new Map(),
) => {
  if (cell.terrainHeight <= Terrain.WATER3) return { i: cell.terrainHeight };

  // If it's a homebase cell or outpost
  if (cell.base_type >= 2) return await userCell(ctx, cell, cellOwners);

  // Otherwise, return a wild monster cell
  return await wildMonsterCell(cell, worldid);
};
