/**
 * Converts a world UUID string into a deterministic 24-bit integer hash.
 * Uses the FNV-1a hashing algorithm.
 *
 * The output is in the range 0–16,777,215 (fits in 24 bits).
 *
 * @param {string} worldId - The UUID of the world.
 * @returns {number} A 24-bit integer hash of the worldId.
 */
const worldIdTo24Bit = (worldId: string): number => {
  let hash = 0x811c9dc5;

  for (let i = 0; i < worldId.length; i++) {
    hash ^= worldId.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193);
  }

  return hash & 0xffffff;
};

/**
 * Generates a deterministic base ID that is safe for use with ActionScript
 * (double-precision numbers), based on worldId and cell coordinates.
 * The worldHash is constrained to 8 digits
 *
 * The format is:
 * [worldHash: 8 digits][X: 3 digits][Y: 3 digits] => 14 digits max.
 *
 * @param {string} worldId - The UUID of the world.
 * @param {number} x - The X coordinate of the cell (max 3 digits, 0–999).
 * @param {number} y - The Y coordinate of the cell (max 3 digits, 0–999).
 * @returns {string} A 14-digit deterministic base ID.
 */
export const generateBaseId = (worldId: string, x: number, y: number) => {
const worldHash = (worldIdTo24Bit(worldId) % 90000000) + 10000000;

  return `${worldHash}${x.toString().padStart(3, "0")}${y
    .toString()
    .padStart(3, "0")}`;
};
