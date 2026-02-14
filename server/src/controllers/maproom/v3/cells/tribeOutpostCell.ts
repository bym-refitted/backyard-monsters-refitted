import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { EnumYardType } from "../../../../enums/EnumYardType.js";
import { Tribes } from "../../../../enums/Tribes.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { generateBaseId } from "../../../../utils/generateBaseId.js";
import { calculateStructureLevel } from "../../../../services/maproom/v3/calculateStructureLevel.js";
import type { CellData } from "../../../../types/CellData.js";
import { MapRoomVersion } from "../../../../enums/MapRoom.js";

export const tribeOutpostCell = async (cell: WorldMapCell, worldId: string): Promise<CellData> => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const level = calculateStructureLevel(cellX, cellY, EnumYardType.OUTPOST);
  const baseid = generateBaseId(worldId, cellX, cellY, MapRoomVersion.V3);

  const altitude = 5 + (cellX * 73 + cellY * 31) % 45;

  return {
    uid: 0,
    b: EnumYardType.EMPTY,
    bid: baseid,
    n: Tribes[tribeIndex],
    tid: tribeIndex,
    x: cellX,
    y: cellY,
    i: altitude,
    l: level,
    rel: EnumBaseRelationship.ENEMY,
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
  };
};
