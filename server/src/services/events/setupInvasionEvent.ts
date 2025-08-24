import { devConfig } from "../../config/DevSettings";

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

type InvasionPop = Pick<InvasionEventDates, "start" | "end" | "extension"> & {
  current: number;
};

/**
 * Calculates and returns the timing and phase information for the
 * Wild Monster Invasion event. Determines the event's start, end,
 * and extension periods based on the first day of the current month
 * (or dev override), and computes the current phase based on the
 * present time.
 *
 * @returns {InvasionEventResult} Object containing event dates and phases.
 */
export const setupInvasionEvent = (): InvasionEventResult => {
  const now = new Date();
  let startDate: Date;

  if (devConfig.startEventNowOverride) {
    startDate = new Date(devConfig.startEventNowOverride * 1000);
  } else {
    startDate = new Date(now.getFullYear(), now.getMonth(), 10);
  }

  const endDate = new Date(startDate);
  endDate.setDate(startDate.getDate() + 6);

  const extensionDate = new Date(endDate);
  extensionDate.setDate(endDate.getDate() + 1);

  // Timstamps
  const current = Math.floor(now.getTime() / 1000);
  const start = Math.floor(startDate.getTime() / 1000);
  const end = Math.floor(endDate.getTime() / 1000);
  const extension = Math.floor(extensionDate.getTime() / 1000);

  const invasionpop = getInvasionPop({ current, start, end, extension });
  const invasionpop2 = invasionpop;

  return {
    dates: { start, end, extension },
    phases: { invasionpop, invasionpop2 },
  };
};

/**
 * Determines the current phase of the Wild Monster Invasion event
 * based on the current time relative to the event timeline.
 *
 * - Phase 1: 7+ days before event start
 * - Phase 2: 4-6 days before event start
 * - Phase 3: 1-3 days before event start
 * - Phase 4: During main event period
 * - Phase 5: During extension period
 * - Phase -1: After event has completely ended
 *
 * @param {InvasionPop} params - Object containing timing information
 * @param {number} params.current - Current time
 * @param {number} params.start - Event start time
 * @param {number} params.end - Event end time
 * @param {number} params.extension - Extension end time
 *
 * @returns {number} Phase integer representing the current event state
 */
const getInvasionPop = ({ current, start, end, extension }: InvasionPop) => {
  const SECONDS_PER_DAY = 86400;
  const daysUntilStart = Math.ceil((start - current) / SECONDS_PER_DAY);

  if (current < start) {
    if (daysUntilStart > 6) return 1;
    if (daysUntilStart > 3) return 2;
    if (start - current < SECONDS_PER_DAY && start - current > 0) return 3;
    return 0; // fallback
  }
  if (current < end) return 4;
  if (current < extension) return 5;
  return -1;
};
