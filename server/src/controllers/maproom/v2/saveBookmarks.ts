import { STATUS } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";

export const saveBookmarks: KoaController = async (ctx) => {
  // ToDo: Implement
  ctx.status = STATUS.OK;
  ctx.body = {
    error: 0,
  };
};
