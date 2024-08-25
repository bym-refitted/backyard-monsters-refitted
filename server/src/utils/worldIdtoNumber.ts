/**
 * Converts a world ID string to a numerical value by encoding it to UTF-8 and summing the byte values.
 *
 * @param {string} worldId - The world ID to be converted.
 * @returns {number} The numerical representation of the world ID.
 */
export const worldIdToNumber = (worldId: string) => {
  let utf8Encode = new TextEncoder();
  let test = utf8Encode.encode(worldId);
  return [...test.values()].reduce((val, res) => val + res, 0);
};
