import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { EnumYardType } from "../../../enums/EnumYardType";
import { EnumBaseRelationship } from "../../../enums/EnumBaseRelationship";
import { MapRoom3 } from "../../../enums/MapRoom";
import { generateCells } from "../../../services/maproom/v3/generateCells";
import { CellSchema } from "../../../zod/CellSchema";
import { errorLog } from "../../../utils/logger";
import { loadFailureErr } from "../../../errors/errors";

export const getMapRoomCells: KoaController = async (ctx) => {
  try {
    const { cellids } = CellSchema.parse(ctx.request.body);
    const currentUser: User = ctx.authUser;
    await ORMContext.em.populate(currentUser, ["save"]);

    const allCells = generateCells();

    // If we have cellids, create a Set of positions, then filter using that Set; otherwise, use all cells.
    const cellPositions = cellids?.length
      ? new Set(cellids.map(id => `${id % MapRoom3.WIDTH},${Math.floor(id / MapRoom3.WIDTH)}`))
      : null;
    
    const cells = cellPositions
      ? allCells.filter(cell => cellPositions.has(`${cell.x},${cell.y}`))
      : allCells;

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      celldata: [
        {
          // Example of a tribe
          uid: 0,
          b: EnumYardType.EMPTY,
          bid: 1234,
          n: "Abunakki",
          tid: 0,
          x: 14,
          y: 14,
          l: 25,
          pl: 0,
          r: 0,
          dm: 0,
          rel: EnumBaseRelationship.ENEMY,
          lo: 0,
          fr: 0,
          p: 0,
          d: 0,
          t: 0,
        },
        ...cells,
      ],
    };
  } catch (error) {
    errorLog("Error in getMapRoomCells:", error);
    throw loadFailureErr();
  }
};
