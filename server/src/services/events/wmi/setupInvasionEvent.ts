import { devConfig } from "../../../config/DevSettings.js";
import { Invasion } from "../../../enums/Invasion.js";

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
 * Sets up invasion event dates and phases based on invasion type.
 * Handles different invasions (WMI1, WMI2) with dev overrides and calculates
 * start, end, and extension dates. Creates a 7-day event period starting on the 10th
 * of the appropriate month based on invasion type scheduling.
 *
 * @param {Invasion} type - The type of invasion to set up (WMI1, WMI2, or default)
 * @returns {InvasionEventResult} Object containing timestamps for event dates and calculated phase numbers
 */
export const setupInvasionEvent = (type: Invasion): InvasionEventResult => {
  const now = new Date();
  let startDate: Date;

  switch (type) {
    case Invasion.WMI1:
      if (devConfig.wmi1StartNowOverride) {
        startDate = new Date(devConfig.wmi1StartNowOverride * 1000);
      } else {
        startDate = getNextInvasionDate(now, 0);
      }
      break;

    case Invasion.WMI2:
      if (devConfig.wmi2StartNowOverride) {
        startDate = new Date(devConfig.wmi2StartNowOverride * 1000);
      } else {
        startDate = getNextInvasionDate(now, 1);
      }
      break;

    default:
      startDate = new Date(now.getFullYear(), now.getMonth(), 10);
      break;
  }

  const endDate = new Date(startDate);
  endDate.setDate(startDate.getDate() + 7);

  const extensionDate = new Date(endDate);
  extensionDate.setDate(endDate.getDate());

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
 * Calculates invasion phase based on current timestamp relative to event dates.
 * Returns different phase numbers: 1-3 for pre-invasion countdown (based on days remaining),
 * 4 for active invasion period, 5 for extension period, and -1 for post-event.
 * Uses day-based thresholds to determine which phase the invasion is currently in.
 *
 * @param {InvasionPop} params - Object containing current timestamp and event start/end/extension timestamps
 * @returns {number} Phase number indicating invasion status (-1, 0-5)
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

/**
 * Gets the next invasion date based on month parity scheduling system.
 * WMI1 invasions occur in odd months, WMI2 in even months, always on the 10th.
 * If current month matches the parity, returns 10th of current month, otherwise
 * returns 10th of next month to maintain the alternating schedule.
 *
 * @param {Date} now - Current date to calculate from
 * @param {0 | 1} monthParity - Month parity (0 for even months, 1 for odd months)
 * @returns {Date} Next invasion start date set to the 10th of the appropriate month
 */
const getNextInvasionDate = (now: Date, monthParity: 0 | 1): Date => {
  const currentMonth = now.getMonth() + 1;

  if (currentMonth % 2 === monthParity)
    return new Date(now.getFullYear(), currentMonth - 1, 10);
  else return new Date(now.getFullYear(), currentMonth, 10);
};
