import { Loaded } from "@mikro-orm/core";
import { ValueNoise } from "value-noise-js/dist/value-noise";
import { WorldMapCell } from "../models/worldmapcell.model";
import { Terrain } from "../controllers/maproom/v2/terrain/Terrain";
import { homeCell } from "../controllers/maproom/v2/cells/homeCell";
import { Context } from "koa";
import { TRIBES } from "../enums/Tribes";

/**
 * The scale factor for noise generation. This value determines the frequency of the noise.
 * A higher value results in larger, more spread-out features, while a lower value results in smaller, more detailed features.
 * @type {number}
 */
export const NOISE_SCALE: number = 3;

/**
 * The scale factor for terrain height. This value determines the range of terrain heights.
 * A higher value results in taller terrain features, while a lower value results in flatter terrain.
 * @type {number}
 */
export const TERRAIN_SCALE: number = 83;

/**
 * Calculates the terrain height at a given cell based on noise values.
 * The noise value is scaled by NOISE_SCALE and then adjusted to fit within the range defined by TERRAIN_SCALE.
 * +1 is added to get rid of the negative values.
 * 
 * Higher terrain: increase the terrain scale.
 * Lower terrain: decrease the terrain scale.
 * 
 * @param {ValueNoise} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate of the cell.
 * @param {number} cellY - The y-coordinate of the cell.
 * @returns {number} - The calculated terrain height for the cell.
 */
export const getTerrainHeight = (
  noise: ValueNoise,
  cellX: number,
  cellY: number
): number =>
  Math.round(
    (noise.evalXY(cellX / NOISE_SCALE, cellY / NOISE_SCALE) + 1) * TERRAIN_SCALE
  );

export const getNoise = (seed: string) => new ValueNoise(seed, undefined, "perlin");

export const buildCellPayload = async (
  cell: Loaded<WorldMapCell, never>,
  ctx: Context
) => {
  if (cell.terrainHeight <= Terrain.WATER3) return { i: cell.terrainHeight };

  // If it's a homebase cell or outpost
  if (cell.base_type >= 2) return await homeCell(ctx, cell);

  const tribeIndex = (cell.x + cell.y) % TRIBES.length;
  let baseId = 1000000 + cell.y + cell.x * 1000;

  return {
    uid: baseId,
    b: 1,
    i: cell.terrainHeight,
    bid: baseId,
    n: TRIBES[tribeIndex],
    l: 40,
    dm: 0,
    d: 0,
  };
};
