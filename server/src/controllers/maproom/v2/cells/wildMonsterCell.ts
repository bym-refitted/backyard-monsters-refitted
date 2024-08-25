import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { Tribes } from "../../../../enums/Tribes";

export const wildMonsterCell = async (cell: WorldMapCell) => {
  const tribeIndex = (cell.x + cell.y) % Tribes.length;
  let baseId = 1000000 + cell.y + cell.x * 1000;

  return {
    uid: baseId,
    b: 1,
    i: cell.terrainHeight,
    bid: baseId,
    n: Tribes[tribeIndex],
    l: 40,        // TODO: Implement level
    dm: 0,        // TODO: Implement damage
    d: 0,         // TODO: Implement Base destroyed
  };
};
