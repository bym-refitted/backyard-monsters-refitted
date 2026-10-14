import { EVENTS } from "../../../config/EventCalendarConfig.js";
import { Event } from "../../../database/models/event.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import type { ScheduledEvent } from "../calendar/eventCalendar.js";

/**
 * Gets a player's score in a scheduled event.
 *
 * @param {number} userid - The player
 * @param {ScheduledEvent} scheduled - The scheduled event
 * @returns {Promise<number>} The score, or 0 when the player has not scored yet
 */
export const getEventScore = async (userid: number, scheduled: ScheduledEvent): Promise<number> => {
  const { event, start } = scheduled;
  const progress = await postgres.em.findOne(Event, { userid, event, start_time: start });

  if (!progress) return 0;

  return progress.score;
};

/**
 * Adds points to a player's score in a scheduled event.
 * Points only count while the event is running, and never past the event's maximum score.
 *
 * @param {number} userid - The player
 * @param {ScheduledEvent} scheduled - The scheduled event
 * @param {number} delta - The points gained
 * @returns {Promise<number | undefined>} The new score, or undefined when the points were not accepted
 */
export const addEventScore = async (userid: number, scheduled: ScheduledEvent, delta: number) => {
  const { event, start, end } = scheduled;
  const now = getCurrentDateTime();
  
  const isRunning = start <= now && now < end;
  if (!isRunning) return undefined;

  const where = { userid, event, start_time: start };

  const existing = await postgres.em.findOne(Event, where);

  const currentScore = existing ? existing.score : 0;
  const score = currentScore + delta;
  
  const { maxScore } = EVENTS[event];

  if (maxScore !== undefined && score > maxScore) return undefined;

  const progress = existing ?? postgres.em.create(Event, where);

  progress.score = score;
  await postgres.em.persist(progress).flush();

  return score;
};
