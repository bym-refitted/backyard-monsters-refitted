import type { Context } from "koa";
import type { Loaded } from "@mikro-orm/core";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { wildMonsterCell, type WildMonsterCellFields } from "../../../controllers/maproom/v3/cells/wildMonsterCell.js";
import { tribeOutpostCell, type TribeOutpostCellFields } from "../../../controllers/maproom/v3/cells/tribeOutpostCell.js";
import { terrainCell } from "../../../controllers/maproom/v3/cells/terrainCell.js";
import { playerCell, type PlayerCellFields, type PlayerCellOwner } from "../../../controllers/maproom/v3/cells/playerCell.js";
import type { CellData } from "../../../types/CellData.js";

export type MapCell = Loaded<WorldMapCell, "save", PlayerCellFields | WildMonsterCellFields | TribeOutpostCellFields>;

/**
 * Constructs the necessary data object of a cell on the world map.
 * Checks ownership first (uid > 0) to route to playerCell, mirroring
 * the MR2 pattern where base_type >= 2 indicates a player-owned cell.
 *
 * @param {MapCell} cell - The world map cell, with every save field its handlers read.
 * @param {string} worldid - The world ID.
 * @param {Context} ctx - The Koa context object.
 * @param {Map<number, PlayerCellOwner>} cellOwners - Pre-loaded map of user IDs to cell owners.
 * @returns {Promise<CellData>} - The data object for the cell.
 */
export const createCellData = async (
  cell: MapCell,
  worldid: string,
  ctx: Context,
  cellOwners: Map<number, PlayerCellOwner> = new Map(),
): Promise<CellData> => {
  if (cell.uid > 0) return await playerCell(ctx, cell, cellOwners);

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
