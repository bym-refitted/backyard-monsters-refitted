import { Invasion } from "../../enums/Invasion";
import { Status } from "../../enums/StatusCodes";
import { setupInvasionEvent } from "../../services/events/setupInvasionEvent";
import { KoaController } from "../../utils/KoaController";

export const wildMonsterInvasion: KoaController = async (ctx) => {
  const { type } = ctx.query;

  if (!type) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "Missing required event parameters" };
    return;
  }

  if (type !== Invasion.WMI1 && type !== Invasion.WMI2) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "Invalid invasion event" };
    return;
  }

  const eventData = setupInvasionEvent(type);

  ctx.status = Status.OK;
  ctx.body = eventData.dates;
};
