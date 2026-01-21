import { Invasion } from "../../enums/Invasion.js";
import { Status } from "../../enums/StatusCodes.js";
import { setupInvasionEvent } from "../../services/events/wmi/setupInvasionEvent.js";
import { KoaController } from "../../utils/KoaController.js";

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
