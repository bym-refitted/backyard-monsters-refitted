import type { Loaded } from "@mikro-orm/core";
import { WorldMapCell } from "../../../../database/models/worldmapcell.model.js";
import { Tribes } from "../../../../enums/Tribes.js";
import { calculateTribeLevel } from "../../../../services/maproom/v2/calculateTribeLevel.js";
import { MapRoomCell } from "../../../../enums/MapRoom.js";
import { generateBaseId } from "../../../../utils/generateBaseId.js";

export type WildMonsterCellFields = "*" | "save.damage" | "save.destroyed";

type Cell = Loaded<WorldMapCell, "save", WildMonsterCellFields>;

export const wildMonsterCell = async (cell: Cell, worldId: string) => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const tribe = Tribes[tribeIndex];

  const level = calculateTribeLevel(cell.x, cell.y, tribe);

  const baseid = generateBaseId(worldId, cellX, cellY);
  
  return {
    uid: 0,
    b: MapRoomCell.WM,
    i: cell.terrainHeight,
    bid: baseid,
    n: Tribes[tribeIndex],
    l: level,
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
  };
};
