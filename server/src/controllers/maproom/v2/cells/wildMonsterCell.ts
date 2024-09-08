import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { Tribes } from "../../../../enums/Tribes";
import { calculateTribeLevel } from "../../../../services/maproom/v2/calculateTribeLevel";
import { MapRoomCell } from "../../../../enums/MapRoom";

export const wildMonsterCell = async (cell: WorldMapCell, worldId: string) => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;
  const tribe = Tribes[tribeIndex];

  let baseId = 1000000 + cell.y + cell.x * 1000;
  const level = calculateTribeLevel(cell.x, cell.y, worldId, tribe);

  return {
    uid: baseId,
    b: MapRoomCell.WM,
    i: cell.terrainHeight,
    bid: baseId,
    n: Tribes[tribeIndex],
    l: level,
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
  };
};
