import { User } from "../../database/models/user.model.js";
import { Status } from "../../enums/StatusCodes.js";
import { EventIdSchema, UpdateEventScoreSchema } from "../../schemas/ReplayableEventSchemas.js";
import { getActiveReplayableEvent } from "../../services/events/calendar/eventCalendar.js";
import { addEventScore, getEventScore } from "../../services/events/replayable/eventScore.js";
import { getEventBases } from "../../services/events/replayable/eventBases.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Acknowledges the replayable event calls the server has nothing to do for:
 * startevent, resetevent, emailoptin and, until it is built, copybase.
 *
 * A player's score is stored against the start time of the scheduled event, so a
 * new run has no score to start or reset.
 */
export const acknowledgeEvent: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};

/**
 * Returns the player's score in an active replayable event.
 * The response carries no `score` when the event is not active, which the client ignores.
 *
 * @param {Context} ctx - Koa context.
 */
export const getReplayableEventScore: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { eventid } = EventIdSchema.parse(ctx.request.body);

  const scheduled = getActiveReplayableEvent(eventid);

  if (!scheduled) {
    ctx.status = Status.OK;
    ctx.body = { error: 0 };
    return;
  }

  const score = await getEventScore(user.userid, scheduled);

  ctx.status = Status.OK;
  ctx.body = { error: 0, score };
};

/**
 * Adds the points the client reports to the player's score, and returns the new score.
 *
 * The response carries no `score` when the points are not accepted. The client ignores a
 * missing one, whereas a score lower than its own makes AttackDefend.as post the
 * difference again, indefinitely.
 *
 * @param {Context} ctx - Koa context.
 */
export const updateReplayableEventScore: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { eventid, delta } = UpdateEventScoreSchema.parse(ctx.request.body);

  const scheduled = getActiveReplayableEvent(eventid);

  if (!scheduled) {
    ctx.status = Status.OK;
    ctx.body = { error: 0 };
    return;
  }

  const score = await addEventScore(user.userid, scheduled, delta);

  ctx.status = Status.OK;
  ctx.body = { error: 0, score };
};

/**
 * Returns the bases the player attacks during an AttackDefend event.
 * The client reads the response as an ordered list of `{ id, level }`,
 * and attacks the entry at the index of the number of bases it has destroyed.
 *
 * @param {Context} ctx - Koa context.
 */
export const loadEventBases: KoaController = async (ctx) => {
  const { eventid } = EventIdSchema.parse(ctx.request.body);

  const scheduled = getActiveReplayableEvent(eventid);

  if (!scheduled) {
    ctx.status = Status.OK;
    ctx.body = [];
    return;
  }

  const bases = getEventBases(scheduled.event);

  ctx.status = Status.OK;
  ctx.body = bases;
};
