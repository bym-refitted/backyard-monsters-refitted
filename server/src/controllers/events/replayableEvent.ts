import { EVENTS } from "../../config/EventCalendarConfig.js";
import { Event } from "../../database/models/event.model.js";
import { User } from "../../database/models/user.model.js";
import { Status } from "../../enums/StatusCodes.js";
import { EventIdSchema, UpdateEventScoreSchema } from "../../schemas/ReplayableEventSchemas.js";
import { getActiveReplayableEvent } from "../../services/events/calendar/eventCalendar.js";
import { getEventRewardFields } from "../../services/events/replayable/eventRewards.js";
import { addEventScore, getEventScore } from "../../services/events/replayable/eventScore.js";
import { copyEventBase, getEventBases } from "../../services/events/replayable/eventBases.js";
import { postgres } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";

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

  await postgres.em.populate(user, ["save"]);
  const rewardFields = await getEventRewardFields(user.save!, scheduled.event, score);

  ctx.status = Status.OK;
  ctx.body = { error: 0, score, ...rewardFields };
};

/**
 * Adds the points the client reports to the player's score, and returns the new score.
 * Only events marked `clientScored` take points from the client; the rest are scored by the server.
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
  const isClientScored = scheduled ? EVENTS[scheduled.event].clientScored : false;

  if (!scheduled || !isClientScored) {
    ctx.status = Status.OK;
    ctx.body = { error: 0 };
    return;
  }

  const score = await addEventScore(user.userid, scheduled, delta);

  await postgres.em.populate(user, ["save"]);
  const rewardFields = await getEventRewardFields(user.save!, scheduled.event, score);

  ctx.status = Status.OK;
  ctx.body = { error: 0, score, ...rewardFields };
};

/**
 * Returns the bases the player attacks during an event, as an ordered list of
 * `{ id, level, destroyed }`. AttackDefend events attack the entry at the index of the
 * number of bases destroyed; YardCrawl events attack the first one not yet destroyed.
 *
 * @param {Context} ctx - Koa context.
 */
export const loadEventBases: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { eventid } = EventIdSchema.parse(ctx.request.body);

  const scheduled = getActiveReplayableEvent(eventid);

  if (!scheduled) {
    ctx.status = Status.OK;
    ctx.body = [];
    return;
  }

  const { event, start } = scheduled;
  const where = { userid: user.userid, event, start_time: start };
  
  const progress = await postgres.em.findOne(Event, where);

  const bases = getEventBases(event, progress);

  ctx.status = Status.OK;
  ctx.body = bases;
};

/**
 * Copies the player's own base for the last attack of an event, and returns its base ID.
 * The client asks several times, so the copy is made once and the same ID returned after.
 * The response carries no `baseid` when there is no copy to attack, which the client ignores.
 *
 * @param {Context} ctx - Koa context.
 */
export const copyReplayableEventBase: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { eventid } = EventIdSchema.parse(ctx.request.body);

  const scheduled = getActiveReplayableEvent(eventid);

  if (!scheduled) {
    ctx.status = Status.OK;
    ctx.body = { error: 0 };
    return;
  }

  await postgres.em.populate(user, ["save"]);

  const baseid = await copyEventBase(user, scheduled);

  ctx.status = Status.OK;
  ctx.body = { error: 0, baseid };
};
