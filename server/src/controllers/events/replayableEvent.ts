import { Status } from "../../enums/StatusCodes.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Stub for the replayable event calls the server does not act on yet:
 * startevent, resetevent, emailoptin, copybase, updatescore and geteventscore.
 *
 * The response deliberately carries no `score` or `baseid`. The client ignores a
 * missing one, whereas a score lower than its own makes AttackDefend.as post the
 * difference again, indefinitely.
 *
 * TODO: Replace with real handlers
 */
export const acknowledgeEvent: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};

/**
 * Stub for the list of yards the player attacks during an AttackDefend event.
 * The client reads the response as an ordered list of `{ id, destroyed, level }`.
 *
 * TODO: Return the Brukkarg yards
 */
export const loadEventBases: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = [];
};
