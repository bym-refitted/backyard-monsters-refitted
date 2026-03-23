export type Coord = Readonly<{ x: number; y: number }>;

interface Bounds {
  minX: number;
  maxX: number;
  minY: number;
  maxY: number;
}

/**
 * Computes the bounding box for an array of coordinates.
 * Used to create efficient range queries for database lookups.
 *
 * @param {Coord[]} coords - Array of coordinate objects with x and y properties.
 * @returns {Bounds} - The min/max X and Y values forming the bounding box.
 */
export const getCellBounds = (coords: Coord[]): Bounds => {
  let minX = Infinity, maxX = -Infinity;
  let minY = Infinity, maxY = -Infinity;

  for (const { x, y } of coords) {
    minX = Math.min(minX, x);
    maxX = Math.max(maxX, x);
    minY = Math.min(minY, y);
    maxY = Math.max(maxY, y);
  }

  return { minX, maxX, minY, maxY };
}

