/**
 * Hexagonal offsets for placing defenders around a cell.
 * These 6 positions form a hexagon around a center point.
 */
export const DEFENDER_OFFSETS = [
  [-1, 0], [1, 0],
  [-1, 1], [0, 1],
  [-1, -1], [0, -1],
] as const;

/**
 * Gets the 6 defender outpost positions around a cell.
 * 
 * @param {number} centerX  - The X coordinate of the center
 * @param {number} centerY - The Y coordinate of the center
 * @returns Array of 6 absolute coordinate pairs
 */
export const getDefenderOutposts = (centerX: number, centerY: number) => {
  return DEFENDER_OFFSETS.map(([dx, dy]) => [centerX + dx, centerY + dy]);
};
