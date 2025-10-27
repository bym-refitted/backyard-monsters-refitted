import { CELL_EDGE } from "../../../../config/WorldGenSettings";
import { MapRoom3 } from "../../../../enums/MapRoom";

/**
 * Checks if a position is within valid bounds of the map room.
 * 
 * @param {number} x - The x-coordinate to check
 * @param {number} y - The y-coordinate to check
 * @returns True if the position is within the valid playable area (excluding edge cells)
 */
export const isValidPosition = (x: number, y: number): boolean => {
  return (
    x >= CELL_EDGE && x < MapRoom3.WIDTH - CELL_EDGE &&
    y >= CELL_EDGE && y < MapRoom3.HEIGHT - CELL_EDGE
  );
};
