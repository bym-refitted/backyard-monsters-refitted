import type { Context } from "koa";
import type { Loaded } from "@mikro-orm/core";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { wildMonsterCell } from "../../../controllers/maproom/v3/cells/wildMonsterCell.js";
import { tribeOutpostCell } from "../../../controllers/maproom/v3/cells/tribeOutpostCell.js";
import { terrainCell } from "../../../controllers/maproom/v3/cells/terrainCell.js";
import { playerCell } from "../../../controllers/maproom/v3/cells/playerCell.js";
import type { User } from "../../../models/user.model.js";
import type { CellData } from "../../../types/CellData.js";

/**
 * Constructs the necessary data object of a cell on the world map.
 * Checks ownership first (uid > 0) to route to playerCell, mirroring
 * the MR2 pattern where base_type >= 2 indicates a player-owned cell.
 *
 * @param {Loaded<WorldMapCell, never>} cell - The world map cell to create data for.
 * @param {string} worldid - The world ID.
 * @param {Context} ctx - The Koa context object.
 * @param {Map<number, User>} cellOwners - Pre-loaded map of user IDs to User entities.
 * @returns {Promise<CellData>} - The data object for the cell.
 */
export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  worldid: string,
  ctx: Context,
  cellOwners: Map<number, User> = new Map(),
): Promise<CellData> => {
  if (cell.uid > 0) return playerCell(ctx, cell, cellOwners);

  switch (cell.base_type) {
    case EnumYardType.STRONGHOLD:
    case EnumYardType.RESOURCE:
    case EnumYardType.FORTIFICATION:
      return wildMonsterCell(cell, worldid);

    case EnumYardType.OUTPOST:
      return tribeOutpostCell(cell, worldid);

    case EnumYardType.BORDER:
      return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });

    default:
      return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });
  }
};
