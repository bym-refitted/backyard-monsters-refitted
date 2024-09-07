/**
 * Returns the current date and time as a Unix timestamp in seconds.
 *
 * @returns {number} The current Unix timestamp in seconds.
 */
export const getCurrentDateTime = (): number => Math.floor(Date.now() / 1000);
