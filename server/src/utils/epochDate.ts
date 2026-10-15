/**
 * Gets the calendar date a game timestamp falls on, in a time zone.
 *
 * @param {number} seconds - The game timestamp, in seconds
 * @param {string} timeZone - The time zone to read the date in
 * @returns {Temporal.PlainDate} The date
 */
export const epochToDate = (seconds: number, timeZone: string) => {
  const instant = Temporal.Instant.fromEpochMilliseconds(seconds * 1000);

  return instant.toZonedDateTimeISO(timeZone).toPlainDate();
};

/**
 * Gets the game timestamp of midnight on a date, in a time zone.
 *
 * @param {Temporal.PlainDate} date - The date
 * @param {string} timeZone - The time zone the date is in
 * @returns {number} The game timestamp, in seconds
 */
export const dateToEpoch = (date: Temporal.PlainDate, timeZone: string) => {
  const midnight = date.toZonedDateTime(timeZone);

  return midnight.epochMilliseconds / 1000;
};
