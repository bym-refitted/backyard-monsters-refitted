import { devConfig } from "../../config/DevSettings";

/**
 * Wild Monster Invasion Event Controller
 *
 * Returns event timing data for a monthly recurring event that runs for 7 days
 * with an additional 2-day extension period (9 days total). By default, the event
 * starts on the 1st of each month at midnight.
 *
 * Can override the start time with the 'startEventNowOverride' flag
 * and the event will start immediately from the current date and time.
 *
 * @param {Context} ctx - Koa context object
 * @returns Event timing object with Unix timestamps (seconds)
 */
export const setupInvasionEvent = () => {
  let startDate: Date;

  if (devConfig.startEventNowOverride) {
    // startDate = new Date(devConfig.startEventNowOverride * 1000);
    const fiveDaysFromNow = Math.floor(Date.now() / 1000) + 5 * 24 * 60 * 60;
    startDate = new Date(fiveDaysFromNow * 1000);
  } else {
    const now = new Date();
    startDate = new Date(now.getFullYear(), now.getMonth(), 1);
  }

  const endDate = new Date(startDate);
  endDate.setDate(startDate.getDate() + 7);

  const extensionDate = new Date(endDate);
  extensionDate.setDate(endDate.getDate() + 2);

  const startTimestamp = Math.floor(startDate.getTime() / 1000);
  const endTimestamp = Math.floor(endDate.getTime() / 1000);
  const extensionTimestamp = Math.floor(extensionDate.getTime() / 1000);

  // Calculate current phase based on time
  const now = new Date();
  const currentTimestamp = Math.floor(now.getTime() / 1000);

  const DAYS = 24 * 60 * 60;

  // Phase thresholds (days before event start)
  const phases = [
    { threshold: startTimestamp - 7 * DAYS, phase: -1 },
    { threshold: startTimestamp - 4 * DAYS, phase: 0 },
    { threshold: startTimestamp - 1 * DAYS, phase: 1 },
    { threshold: startTimestamp, phase: 2 },
    { threshold: startTimestamp + 1, phase: 3 },
    { threshold: endTimestamp + 1, phase: 4 },
  ];

  let invasionpop = 5;

  for (const { threshold, phase } of phases) {
    if (currentTimestamp < threshold) {
      invasionpop = phase;
      break;
    }
  }

  const invasionpop2 = Math.max(invasionpop, 4);

  return {
    dates: {
      start: startTimestamp,
      end: endTimestamp,
      extension: extensionTimestamp,
    },
    phases: {
      invasionpop,
      invasionpop2,
    },
  };
};
