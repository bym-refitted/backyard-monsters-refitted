import {
  COUNTDOWN_DAYS,
  EVENT_CYCLE,
  EVENT_START_OVERRIDES,
  EVENT_TIME_ZONE,
  EVENTS,
  POST_EVENT_DAYS,
  SLOT_START_DAY,
} from "../../../config/EventCalendarConfig.js";
import { EventSlot, GameEvent } from "../../../enums/GameEvent.js";
import { dateToEpoch, epochToDate } from "../../../utils/epochDate.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

const SECONDS_PER_DAY = 86400;

const DAYS_PER_WEEK = 7;

const SLOTS = [EventSlot.A, EventSlot.B];

export interface ScheduledEvent {
  event: GameEvent;
  countdown: number;
  start: number;
  end: number;
}

/**
 * Builds a scheduled event from its start time.
 *
 * @param {GameEvent} event - The event
 * @param {number} start - When it starts
 * @returns {ScheduledEvent} The event, with its countdown and end
 */
const toScheduledEvent = (event: GameEvent, start: number): ScheduledEvent => {
  const { countdownDays = COUNTDOWN_DAYS, runDays } = EVENTS[event];

  return {
    event,
    countdown: start - countdownDays * SECONDS_PER_DAY,
    start,
    end: start + runDays * SECONDS_PER_DAY,
  };
};

/**
 * Gets the start time set for an event in `EVENT_START_OVERRIDES`.
 * An event with an override starts at that time instead of following the calendar.
 *
 * @param {GameEvent} event - The event to look up
 * @returns {number} The override as a Unix timestamp in seconds, or 0 when the event has none
 */
export const getEventOverride = (event: GameEvent): number => EVENT_START_OVERRIDES[event];

/**
 * Checks whether any event has a start override set. A forced event takes over from the
 * calendar, so every calendar event without an override is hidden until the overrides are cleared.
 *
 * @returns {boolean} Whether an override is set
 */
const hasForcedEvent = () => Object.values(GameEvent).some((event) => getEventOverride(event) > 0);

/**
 * Lists what the calendar holds from last month to one full cycle ahead, which is
 * always enough to contain the current and the next date of every event.
 *
 * @param {number} now - The current time
 * @returns {ScheduledEvent[]} The scheduled events, in date order
 */
const getEventSchedule = (now: number): ScheduledEvent[] => {
  const thisMonth = epochToDate(now, EVENT_TIME_ZONE).toPlainYearMonth();
  
  const schedule: ScheduledEvent[] = [];

  for (let offset = -1; offset <= EVENT_CYCLE.length; offset++) {
    const month = thisMonth.add({ months: offset });
    const monthIndex = month.year * 12 + month.month - 1;
    const cycleMonth = EVENT_CYCLE[monthIndex % EVENT_CYCLE.length]!;

    for (const slot of SLOTS) {
      const startDate = month.toPlainDate({ day: SLOT_START_DAY[slot] });
      const start = dateToEpoch(startDate, EVENT_TIME_ZONE);

      for (const event of cycleMonth[slot]) schedule.push(toScheduledEvent(event, start));
    }
  }

  return schedule;
};

/**
 * Gets the round of a weekly event that is counting down or running. Rounds start
 * every Monday at midnight; once this week's round has ended, the next one is returned.
 *
 * @param {GameEvent} event - The weekly event
 * @param {number} now - The current time
 * @returns {ScheduledEvent} The round
 */
const getWeeklyRound = (event: GameEvent, now: number): ScheduledEvent => {
  const instant = Temporal.Instant.fromEpochMilliseconds(now * 1000);
  const today = instant.toZonedDateTimeISO(EVENT_TIME_ZONE).toPlainDate();
  const monday = today.subtract({ days: today.dayOfWeek - 1 });

  const start = monday.toZonedDateTime(EVENT_TIME_ZONE).epochMilliseconds / 1000;
  const thisWeek = toScheduledEvent(event, start);

  if (thisWeek.end > now) return thisWeek;

  return toScheduledEvent(event, start + DAYS_PER_WEEK * SECONDS_PER_DAY);
};

/**
 * Gets the scheduled event that is under way, or the next one if none is.
 *
 * A forced start time replaces the calendar for that event, and while any event is forced,
 * every other calendar event is hidden. The calendar's dates are never moved, so an event hidden
 * part-way through shows again, with its remaining time, once the overrides are cleared.
 * Weekly events are never hidden: they return their current round.
 *
 * @param {GameEvent} event - The event
 * @param {number} now - The current time
 * @returns {ScheduledEvent | null} The scheduled event, or null when the event is switched off or hidden
 */
export const getScheduledEvent = (event: GameEvent, now = getCurrentDateTime()): ScheduledEvent | null => {
  const override = getEventOverride(event);
  const isEnabled = EVENTS[event].enabled;
  const isHiddenByOverride = hasForcedEvent();

  if (override) return toScheduledEvent(event, override);

  if (!isEnabled) return null;

  if (EVENTS[event].weekly) return getWeeklyRound(event, now);

  if (isHiddenByOverride) return null;

  const schedule = getEventSchedule(now);

  return schedule.find((scheduled) => scheduled.event === event && scheduled.end > now) ?? null;
};

/**
 * Lists the events players can currently see: counting down, running, or, for the
 * replayable events, showing their closing message.
 *
 * @param {number} now - The current time
 * @returns {ScheduledEvent[]} The active events
 */
export const getActiveEvents = (now = getCurrentDateTime()): ScheduledEvent[] => {
  const active: ScheduledEvent[] = [];

  for (const event of Object.values(GameEvent)) {
    const { replayableId, closingDays = POST_EVENT_DAYS } = EVENTS[event];

    const isReplayable = replayableId !== undefined;
    const closing = isReplayable ? closingDays * SECONDS_PER_DAY : 0;

    const scheduled = getScheduledEvent(event, now - closing);

    if (!scheduled) continue;

    const isAnnounced = scheduled.countdown <= now;
    const isOver = now >= scheduled.end + closing;

    if (isAnnounced && !isOver) active.push(scheduled);
  }

  return active;
};

/**
 * Finds the active replayable event the client is asking about.
 *
 * @param {number} replayableId - The id the client knows the event by
 * @param {number} now - The current time
 * @returns {ScheduledEvent | null} The scheduled event, or null when it is not active
 */
export const getActiveReplayableEvent = (replayableId: number, now = getCurrentDateTime()): ScheduledEvent | null => {
  const activeEvents = getActiveEvents(now);

  return activeEvents.find(({ event }) => EVENTS[event].replayableId === replayableId) ?? null;
};
