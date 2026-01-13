import { Context } from "koa";
import { Loaded } from "@mikro-orm/core";
import { EnumYardType } from "../../../enums/EnumYardType";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { strongholdCell } from "../../../controllers/maproom/v3/cells/strongholdCell";
import { defenderCell } from "../../../controllers/maproom/v3/cells/defenderCell";
import { resourceCell } from "../../../controllers/maproom/v3/cells/resourceCell";
import { tribeOutpostCell } from "../../../controllers/maproom/v3/cells/tribeOutpostCell";
import { terrainCell } from "../../../controllers/maproom/v3/cells/terrainCell";
import { playerCell } from "../../../controllers/maproom/v3/cells/playerCell";

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
