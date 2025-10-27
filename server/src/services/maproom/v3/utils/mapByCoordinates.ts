/**
 * Converts an array of items with x and y coordinates into a Map
 * keyed by a string in the format "x,y". This allows for O(1) lookups
 * of items by their coordinates.
 *
 * @template T - Type of items in the array, must have numeric `x` and `y` properties.
 * @param {T[]} items - Array of items to index by coordinates.
 * @returns {Map<string, T>} A Map where each key is a string `"x,y"` and the value is the corresponding cell.
 */
export const mapByCoordinates = <T extends { x: number; y: number }>(items: T[]) => {
  return new Map(items.map((cell) => [`${cell.x},${cell.y}`, cell]));
};
