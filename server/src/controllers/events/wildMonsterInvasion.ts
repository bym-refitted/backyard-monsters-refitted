import { Status } from "../../enums/StatusCodes";
import { calculateWMIEvent } from "../../services/events/calculateWMIEvent";
import { KoaController } from "../../utils/KoaController";

export const wildMonsterInvasion: KoaController = async (ctx) => {
  const eventData = calculateWMIEvent();

  ctx.status = Status.OK;
  ctx.body = eventData.dates;
};
