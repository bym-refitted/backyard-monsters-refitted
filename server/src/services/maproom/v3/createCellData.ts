import { Context } from "koa";
import { Loaded } from "@mikro-orm/core";
import { EnumYardType } from "../../../enums/EnumYardType";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { strongholdCell } from "../../../controllers/maproom/v3/cells/strongholdCell";
import { defenderCell } from "../../../controllers/maproom/v3/cells/defenderCell";
import { terrainCell } from "../../../controllers/maproom/v3/cells/terrainCell";

export const createCellData = async (
  cell: Loaded<WorldMapCell, never>,
  worldid: string,
  ctx: Context
) => {
  if (!cell.base_type) return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });

  if (cell.base_type === EnumYardType.STRONGHOLD) {
    return strongholdCell(ctx, cell);
  }

  if (cell.base_type === EnumYardType.FORTIFICATION) {
    return defenderCell(ctx, cell);
  }

  return terrainCell({ x: cell.x, y: cell.y, i: cell.terrainHeight });
};
