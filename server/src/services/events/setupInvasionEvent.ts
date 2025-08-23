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
  const now = new Date();
  let startDate: Date;
  let invasionpop: number;

  // TODO: get rid of this hardcoded value + check the monthly logic
  if (devConfig.startEventNowOverride) {
    // startDate = new Date(devConfig.startEventNowOverride * 1000);
    startDate = new Date(1756141530 * 1000);
  } else {
    startDate = new Date(now.getFullYear(), now.getMonth(), 1);
  }

  const endDate = new Date(startDate);
  endDate.setDate(startDate.getDate() + 5);

  const extensionDate = new Date(endDate);
  extensionDate.setDate(endDate.getDate() + 2);

  // Timstamps
  const current = Math.floor(now.getTime() / 1000);
  const start = Math.floor(startDate.getTime() / 1000);
  const end = Math.floor(endDate.getTime() / 1000);
  const extension = Math.floor(extensionDate.getTime() / 1000);

  if (current < start) {
    // TODO: add 2 and 3 based on how many days away event is
    invasionpop = 1; // before
  } else if (current < end) {
    invasionpop = 4; // during
  } else {
    invasionpop = -1; // after
  }

  const invasionpop2 = invasionpop;

  return {
    dates: { start, end, extension },
    phases: { invasionpop, invasionpop2 },
  };
};
