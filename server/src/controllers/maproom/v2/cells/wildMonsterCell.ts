import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { Tribes } from "../../../../enums/Tribes";
import { calculateTribeLevel } from "../../../../services/maproom/v2/calculateTribeLevel";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { worldIdToNumber } from "../../../../utils/worldIdtoNumber";

export const wildMonsterCell = async (cell: WorldMapCell, worldId: string) => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const worldIdNumber = worldIdToNumber(worldId);
  const tribe = Tribes[tribeIndex];

  // Create baseid from current worldid, cellX, and cellY
  // TODO: Find a better way to generate baseid, this is awful.
  const baseid = `${worldIdNumber.toString().padStart(4, "0")}${cellX
    .toString()
    .padStart(3, "0")}${cellY.toString().padStart(3, "0")}`;

  const level = calculateTribeLevel(cell.x, cell.y, tribe);

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
