import { ValueNoise } from "value-noise-js/dist/value-noise";

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
 * Calculates the terrain height of a cell based on noise values.
 * The noise value is scaled by NOISE_SCALE and then adjusted to fit within the range defined by TERRAIN_SCALE.
 * +1 is added to remove negative values.
 *
 * Higher terrain: increase the terrain scale.
 * Lower terrain: decrease the terrain scale.
 *
 * @param {ValueNoise} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate of the cell.
 * @param {number} cellY - The y-coordinate of the cell.
 * @returns {number} - The calculated terrain height for the cell.
 */
export const getTerrainHeight = (noise: ValueNoise, cellX: number, cellY: number) =>
  Math.round(
    (noise.evalXY(cellX / NOISE_SCALE, cellY / NOISE_SCALE) + 1) * TERRAIN_SCALE
  );

/**
 * Generates perlin noise based on a given seed.
 * @param {string} seed - The seed for the noise generator.
 * @returns {ValueNoise} - The noise generator instance.
 */
export const generateNoise = (seed: string) => new ValueNoise(seed, undefined, "perlin");