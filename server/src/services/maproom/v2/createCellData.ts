import type { Loaded } from "@mikro-orm/core";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import type { Context } from "koa";
import { Terrain } from "../../../enums/MapRoom.js";
import { userCell } from "../../../controllers/maproom/v2/cells/userCell.js";
import { wildMonsterCell } from "../../../controllers/maproom/v2/cells/wildMonsterCell.js";
import type { User } from "../../../models/user.model.js";

/**
 * Constructs the necessary data object of a cell on the world map.
 *
 * @param {Loaded<WorldMapCell, never>} cell - The world map cell to create data for.
 * @param {string} worldid - The world ID.
 * @param {Context} ctx - The Koa context object.
 * @param {Map<number, User>} cellOwners - Pre-loaded map of user IDs to User entities (optional for in-memory cells).
 * @returns {Promise<Object>} - The data object for the cell.
 */
export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  worldid: string,
  ctx: Context,
  cellOwners: Map<number, User> = new Map(),
) => {
  if (cell.terrainHeight <= Terrain.WATER3) return { i: cell.terrainHeight };

  // If it's a homebase cell or outpost
  if (cell.base_type >= 2) return await userCell(ctx, cell, cellOwners);

  // Otherwise, return a wild monster cell
  return await wildMonsterCell(cell, worldid);
};
