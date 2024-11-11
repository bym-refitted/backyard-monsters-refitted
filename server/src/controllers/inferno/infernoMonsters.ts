import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";

export const infernoMonsters: KoaController = async ctx => {
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      imonsters: {}
    };
}