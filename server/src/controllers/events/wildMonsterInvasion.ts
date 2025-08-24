import { Status } from "../../enums/StatusCodes";
import { setupInvasionEvent } from "../../services/events/setupInvasionEvent";
import { KoaController } from "../../utils/KoaController";

export const wildMonsterInvasion: KoaController = async (ctx) => {
  const eventData = setupInvasionEvent();

  ctx.status = Status.OK;
  ctx.body = eventData.dates;
};
