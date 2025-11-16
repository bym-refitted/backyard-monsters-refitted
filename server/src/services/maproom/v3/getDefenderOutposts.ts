// ODD-R (odd-row) horizontal hexagon offsets - matches client logic in MapRoom3CellGraphic.as lines 562-603
// Client uses Y coordinate (row) parity, not X coordinate!
// For EVEN rows (y % 2 == 0): left-aligned
const DEFENDER_OFFSETS_EVEN_ROW = [
  [+1,  0],  // E
  [-1,  0],  // W
  [ 0, -1],  // NE
  [-1, -1],  // NW
  [ 0, +1],  // SE
  [-1, +1],  // SW
] as const;

// For ODD rows (y % 2 == 1): right-aligned (shifted right)
const DEFENDER_OFFSETS_ODD_ROW = [
  [+1,  0],  // E
  [-1,  0],  // W
  [+1, -1],  // NE
  [ 0, -1],  // NW
  [+1, +1],  // SE
  [ 0, +1],  // SW
] as const;

export const getHexNeighborOffsets = (x: number, y: number) =>
  y % 2 === 1 ? DEFENDER_OFFSETS_ODD_ROW : DEFENDER_OFFSETS_EVEN_ROW;

export const getDefenderOutposts = (centerX: number, centerY: number) => {
  const offsets = getHexNeighborOffsets(centerX, centerY);
  return offsets.map(([dx, dy]) => [centerX + dx, centerY + dy]);
};
