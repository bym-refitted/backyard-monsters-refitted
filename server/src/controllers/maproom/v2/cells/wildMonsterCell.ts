import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { getTribeLevel, Tribes } from "../../../../enums/Tribes";

export const wildMonsterCell = async (cell: WorldMapCell, worldId: string) => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;
  let baseId = 1000000 + cell.y + cell.x * 1000;
  const tribe = Tribes[tribeIndex];

  return {
    uid: baseId,
    b: 1,
    i: cell.terrainHeight,
    bid: baseId,
    n: Tribes[tribeIndex],
    l: getTribeLevel(cell.x, cell.y, worldId, tribe), // TODO: Implement level
    dm: 0, // TODO: Implement damage
    d: 0, // TODO: Implement Base destroyed
  };
};
