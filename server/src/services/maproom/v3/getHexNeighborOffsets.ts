// ODD-R (odd-row) horizontal hexagon offsets - matches client logic in MapRoom3CellGraphic.as lines 562-603
// For EVEN rows (y % 2 == 0): left-aligned
const HEX_OFFSETS_EVEN_ROW = [
  [+1,  0],  // E
  [-1,  0],  // W
  [ 0, -1],  // NE
  [-1, -1],  // NW
  [ 0, +1],  // SE
  [-1, +1],  // SW
] as const;

// For ODD rows (y % 2 == 1): right-aligned (shifted right)
const HEX_OFFSETS_ODD_ROW = [
  [+1,  0],  // E
  [-1,  0],  // W
  [+1, -1],  // NE
  [ 0, -1],  // NW
  [+1, +1],  // SE
  [ 0, +1],  // SW
] as const;

/**
 * Returns hex neighbor offsets based on row parity.
 * Only Y coordinate matters for determining offset set (odd-row layout).
 *
 * @param y - Row coordinate to determine offset set
 * @returns Array of [dx, dy] offset tuples for the 6 hex neighbors
 */
export const getHexNeighborOffsets = (y: number) => y % 2 === 1 ? HEX_OFFSETS_ODD_ROW : HEX_OFFSETS_EVEN_ROW;

/**
 * Converts odd-r offset coordinates to cube coordinates.
 */
const offsetToCube = (x: number, y: number) => {
  const col = x - (y - (y & 1)) / 2;
  return [col, y, -col - y] as const;
};

/**
 * Returns the hex distance between two cells in odd-r offset coordinates.
 *
 * @param x1 - X coordinate of the first cell
 * @param y1 - Y coordinate of the first cell
 * @param x2 - X coordinate of the second cell
 * @param y2 - Y coordinate of the second cell
 * @returns The hex distance between the two cells
 */
export const getHexDistance = (x1: number, y1: number, x2: number, y2: number): number => {
  const [q1, r1, s1] = offsetToCube(x1, y1);
  const [q2, r2, s2] = offsetToCube(x2, y2);
  return Math.max(Math.abs(q1 - q2), Math.abs(r1 - r2), Math.abs(s1 - s2));
};
