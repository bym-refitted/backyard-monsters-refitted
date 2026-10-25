import { EVENTS } from "../../../config/EventCalendarConfig.js";
import { Event } from "../../../database/models/event.model.js";
import { Save } from "../../../database/models/save.model.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getScheduledEvent } from "../calendar/eventCalendar.js";
import { getTribeTakeoverValue } from "../../maproom/v2/tribeTakeoverValue.js";
import { BaseType } from "../../../enums/Base.js";

/**
 * The empire value an Outpost scores when taken over. A player's Outpost has the value its owner's client last
 * saved. A tribe yard has none saved, so it scores the value of a player's Outpost priced the same as it, from its
 * level.
 *
 * @param {Save} outpost - The Outpost's save, before the takeover
 * @returns {number} The empire value to score
 */
const getTakeoverValue = (outpost: Save) => {
  const isTribe = outpost.type === BaseType.TRIBE;

  return isTribe ? getTribeTakeoverValue(outpost.level) : outpost.empirevalue;
};

/**
 * Adds an Outpost taken over on Map Room 2 to the player's Monster Madness score, at the empire
 * value it had before the takeover, tribe yards included. Only counts while the event is running,
 * and each Outpost only once per run. The score stops at the event's maximum.
 *
 * The score row is persisted, not flushed: the takeover flushes it with the rest of its changes.
 *
 * @param {number} userid - The player taking the Outpost over
 * @param {Save} outpost - The Outpost's save, before its ownership changes
 */
export const scoreOutpostTakeover = async (userid: number, outpost: Save) => {
  const event = GameEvent.MONSTER_MADNESS;
  const scheduled = getScheduledEvent(event);

  if (!scheduled) return;

  const { start, end } = scheduled;
  const now = getCurrentDateTime();

  const isRunning = start <= now && now < end;
  const isOwnOutpost = outpost.userid === userid;

  if (!isRunning || isOwnOutpost) return;

  const where = { userid, event, start_time: start };
  const progress = await postgres.em.findOne(Event, where) ?? postgres.em.create(Event, where);

  const { baseid } = outpost;
  const isAlreadyTaken = progress.taken_outposts.includes(baseid);

  if (isAlreadyTaken) return;

  const maxScore = EVENTS[event].maxScore ?? Infinity;

  progress.score = Math.min(progress.score + getTakeoverValue(outpost), maxScore);
  progress.taken_outposts = [...progress.taken_outposts, baseid];

  postgres.em.persist(progress);
};
