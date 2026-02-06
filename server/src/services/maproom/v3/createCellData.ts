import type { Context } from "koa";
import type { Loaded } from "@mikro-orm/core";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { strongholdCell } from "../../../controllers/maproom/v3/cells/strongholdCell.js";
import { defenderCell } from "../../../controllers/maproom/v3/cells/defenderCell.js";
import { resourceCell } from "../../../controllers/maproom/v3/cells/resourceCell.js";
import { tribeOutpostCell } from "../../../controllers/maproom/v3/cells/tribeOutpostCell.js";
import { terrainCell } from "../../../controllers/maproom/v3/cells/terrainCell.js";
import { playerCell } from "../../../controllers/maproom/v3/cells/playerCell.js";
import type { User } from "../../../models/user.model.js";

/**
 * Constructs the necessary data object of a cell on the world map.
 *
 * @param {Loaded<WorldMapCell, never>} cell - The world map cell to create data for.
 * @param {string} worldid - The world ID.
 * @param {Context} ctx - The Koa context object.
 * @param {Map<number, User>} cellOwners - Pre-loaded map of user IDs to User entities.
 * @returns {Promise<Object>} - The data object for the cell.
 */
export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  worldid: string,
  ctx: Context,
  cellOwners: Map<number, User> = new Map(),
) => {
  switch (cell.base_type) {
    case EnumYardType.PLAYER:
      return playerCell(ctx, cell, cellOwners);

    case EnumYardType.STRONGHOLD:
      return strongholdCell(ctx, cell);

    case EnumYardType.FORTIFICATION:
      return defenderCell(ctx, cell);

    case EnumYardType.RESOURCE:
      return resourceCell(ctx, cell);

    case EnumYardType.OUTPOST:
      return tribeOutpostCell(cell, worldid);

    case EnumYardType.BORDER:
      return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });

    default:
      return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });
  }
};
