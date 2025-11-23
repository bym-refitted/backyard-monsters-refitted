import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { Tribes } from "../../../../enums/Tribes";
import { calculateTribeLevel } from "../../../../services/maproom/v2/calculateTribeLevel";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { generateBaseId } from "../../../../utils/generateBaseId";

export const wildMonsterCell = async (cell: WorldMapCell, worldId: string) => {
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
