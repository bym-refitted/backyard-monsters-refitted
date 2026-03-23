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
 * The worldHash is constrained to 8 digits.
 *
 * MR2 format: [worldHash: 8][X: 3][Y: 3] => 14 digits
 * MR3 format: [3][worldHash: 8][X: 3][Y: 3] => 15 digits
 *
 * Coordinates are always the last 6 digits regardless of version.
 * Max safe integer for AS3 doubles is 2^53-1 (16 digits), so 15 is safe.
 *
 * @param {string} worldId - The UUID of the world.
 * @param {number} x - The X coordinate of the cell (max 3 digits, 0–999).
 * @param {number} y - The Y coordinate of the cell (max 3 digits, 0–999).
 * @param {number} version - Map room version prefix (omitted for MR2, 3 for MR3).
 * @returns {string} A deterministic base ID.
 */
export const generateBaseId = (worldId: string, x: number, y: number, version?: number) => {
  const worldHash = (worldIdTo24Bit(worldId) % 90000000) + 10000000;
  const prefix = version ? `${version}` : "";

  return `${prefix}${worldHash}${x.toString().padStart(3, "0")}${y
    .toString()
    .padStart(3, "0")}`;
};
