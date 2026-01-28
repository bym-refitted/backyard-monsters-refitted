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

export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  ctx: Context,
  worldid?: string,
) => {
  switch (cell.base_type) {
    case EnumYardType.PLAYER:
      return playerCell(ctx, cell);

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
