import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";

export const tribeOutpostCell = async (cell: WorldMapCell): Promise<CellData> => {
  const [cellX, cellY] = [cell.x, cell.y];
  const tribeIndex = (cellX + cellY) % Tribes.length;

  return {
    uid: 0,
    b: EnumYardType.EMPTY,
    bid: 1234,
    n: Tribes[tribeIndex],
    x: cellX,
    y: cellY,
    i: 50,
    l: 50,
    rel: EnumBaseRelationship.ENEMY,
    dm: cell?.save?.damage || 0,
    d: cell?.save?.destroyed || 0,
  };
};
