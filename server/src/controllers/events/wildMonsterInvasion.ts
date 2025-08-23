import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";

export const wildMonsterInvasion: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = {
    start: 1755957124,
    end: 1756561919,
    extension: 1756561919,
  };
};
