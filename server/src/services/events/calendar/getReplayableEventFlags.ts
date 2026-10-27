import { EVENTS } from "../../../config/EventCalendarConfig.js";
import { getActiveEvents } from "./eventCalendar.js";

/**
 * Gets the flags for the replayable events.
 *
 * activeevents lists the replayable events the calendar has running, each with the id
 * the client knows it by and its start time. The client shows the one the player qualifies for.
 *
 * ers stays off: it lets the client schedule events for itself, which the calendar replaces.
 */
export const getReplayableEventFlags = () => {
  const activeevents = getActiveEvents()
    .filter(({ event }) => EVENTS[event].replayableId)
    .map(({ event, start }) => ({ id: EVENTS[event].replayableId, start }));

  return { ers: 0, activeevents };
};
