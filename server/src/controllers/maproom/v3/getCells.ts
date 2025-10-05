import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
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

    if (!cellids?.length) {
      ctx.status = Status.OK;
      ctx.body = { celldata: [] };
      return;
    }

    const allCells = generateCells();
    const coords = new Set(
      cellids.map(
        (id) => `${id % MapRoom3.WIDTH},${Math.floor(id / MapRoom3.WIDTH)}`
      )
    );

    const cells = allCells.filter((cell) => coords.has(`${cell.x},${cell.y}`));

    ctx.status = Status.OK;
    ctx.body = { celldata: [...cells] };
  } catch (error) {
    errorLog("Error in getMapRoomCells:", error);
    throw loadFailureErr();
  }
};
