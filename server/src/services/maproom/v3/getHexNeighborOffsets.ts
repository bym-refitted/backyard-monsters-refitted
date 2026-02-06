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
