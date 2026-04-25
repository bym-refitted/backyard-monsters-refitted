/**
 * Determines whether a Discord account meets the minimum age requirement of 7 days.
 *
 * @param {string} snowflakeId - The Discord snowflake ID of the account.
 * @returns {boolean} True if the account is older than 7 days, false otherwise.
 */
export const isDiscordAccountOldEnough = (snowflakeId: string): boolean => {
  const discordEpoch = 1420070400000;
  const timestamp = Number(BigInt(snowflakeId) >> 22n) + discordEpoch;
  const sevenDaysAgo = new Date();

  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
  return new Date(timestamp) < sevenDaysAgo;
};
