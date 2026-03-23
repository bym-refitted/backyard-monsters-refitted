import type { CellData } from "../../../../types/CellData.js";

/**
 * Formats a terrain cell (bush/clover or empty) for Map Room 3
 *
 * Terrain cells only contain altitude and coordinates.
 * The client will render bushes/clover based on the altitude value.
 *
 * @param cell - Generated cell with x, y, i (altitude)
 * @returns Minimal terrain cell data
 */
export const terrainCell = (cell: CellData): CellData => {
  return { x: cell.x, y: cell.y, i: cell.i };
};
