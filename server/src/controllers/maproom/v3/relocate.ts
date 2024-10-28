import { STATUS } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";

export const relocate: KoaController = async (ctx) => {
  ctx.status = STATUS.OK;
  ctx.body = {
    error: 0,
    mapheaderurl: "http://localhost:3001/api/bm/getnewmap", // Reminder: put in ENV
  };
};
