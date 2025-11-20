import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { Tribes } from "../../../../enums/Tribes";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";
import { worldIdToNumber } from "../../../../utils/worldIdtoNumber";

export const tribeOutpostCell = async (cell: WorldMapCell, worldId: string): Promise<CellData> => {
  const [cellX, cellY] = [cell.x, cell.y];

  const tribeIndex = (cellX + cellY) % Tribes.length;
  const worldIdNumber = worldIdToNumber(worldId);

  const baseid = `${worldIdNumber.toString().padStart(4, "0")}${cellX
    .toString()
    .padStart(3, "0")}${cellY.toString().padStart(3, "0")}`;

  return {
    uid: 0,
    b: EnumYardType.EMPTY,
    bid: baseid,
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
