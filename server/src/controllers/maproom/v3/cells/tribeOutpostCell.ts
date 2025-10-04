import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateTribeLevel } from "../../../../services/maproom/v2/calculateTribeLevel";

export const tribeOutpostCell = async (cell: WorldMapCell) => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const tribe = Tribes[tribeIndex];

  const level = calculateTribeLevel(cell.x, cell.y, tribe);

  return {
    uid: 0,
    b: EnumYardType.EMPTY,
    bid: 1234,
    n: Tribes[tribeIndex],
    x: 14,
    y: 14,
    i: 0,
    l: level,
    rel: EnumBaseRelationship.ENEMY,
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
  };
};
