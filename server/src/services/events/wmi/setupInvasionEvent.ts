import { Invasion } from "../../../enums/Invasion.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { getScheduledEvent } from "../calendar/eventCalendar.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

interface InvasionEventPhases {
  invasionpop: number;
  invasionpop2: number;
}

interface InvasionEventDates {
  start: number;
  end: number;
  extension: number;
}

interface InvasionEventResult {
  dates: InvasionEventDates;
  phases: InvasionEventPhases;
}

type InvasionPop = Pick<InvasionEventDates, "start" | "end"> & {
  current: number;
  countdown: number;
};

const invasionEvents: Record<Invasion, GameEvent> = {
  [Invasion.WMI1]: GameEvent.WMI1,
  [Invasion.WMI2]: GameEvent.WMI2,
};

const noInvasion: InvasionEventResult = {
  dates: { start: 0, end: 0, extension: 0 },
  phases: { invasionpop: -1, invasionpop2: -1 },
};

/**
 * Sets up invasion event dates and phases from the event calendar.
 * The invasion stays hidden (phase -1) until its countdown begins, and when it is switched off.
 *
 * @param {Invasion} type - The type of invasion to set up (WMI1 or WMI2)
 * @returns {InvasionEventResult} Object containing timestamps for event dates and calculated phase numbers
 */
export const setupInvasionEvent = (type: Invasion): InvasionEventResult => {
  const scheduled = getScheduledEvent(invasionEvents[type]);

  if (!scheduled) return noInvasion;

  const { countdown, start, end } = scheduled;
  
  const current = getCurrentDateTime();
  const invasionpop = getInvasionPop({ current, countdown, start, end });

  return {
    dates: { start, end, extension: end },
    phases: { invasionpop, invasionpop2: invasionpop },
  };
};

/**
 * Calculates invasion phase based on current timestamp relative to event dates.
 * Returns different phase numbers: 1-3 for pre-invasion countdown (based on days remaining),
 * 4 for active invasion period, and -1 before the countdown begins and post-event.
 * Uses day-based thresholds to determine which phase the invasion is currently in.
 *
 * @param {InvasionPop} params - Object containing current timestamp and event countdown/start/end timestamps
 * @returns {number} Phase number indicating invasion status (-1, 1-4)
 */
const getInvasionPop = ({ current, countdown, start, end }: InvasionPop) => {
  const SECONDS_PER_DAY = 86400;

  if (current < countdown) return -1;

  const daysUntilStart = Math.ceil((start - current) / SECONDS_PER_DAY);

  if (current < start) {
    if (daysUntilStart > 6) return 1;
    if (daysUntilStart > 3) return 2;
    return 3;
  }

  if (current < end) return 4;

  return -1;
};
