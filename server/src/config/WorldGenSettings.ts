import alea from "alea";
import { createNoise2D, NoiseFunction2D } from "simplex-noise";
import { MapRoom, Terrain } from "../enums/MapRoom";

/**
 * Represents the size of the world map.
 * @constant {number[]}
 */
export const WORLD_SIZE = [MapRoom.HEIGHT, MapRoom.WIDTH];

/**
 * The scale factor for noise generation. This value determines the frequency of the noise.
 * A higher value results in larger, more spread-out features, while a lower value results in smaller, more detailed features.
 * @constant {number}
 */
export const NOISE_SCALE = 12;

/**
 * The scale factor for terrain height. This value determines the range of terrain heights.
 * A higher value results in taller terrain features, while a lower value results in flatter terrain.
 * @constant {number}
 */
export const TERRAIN_SCALE = 95;

/**
 * Smooths the height value by averaging the values of the surrounding cells.
 *
 * @param {NoiseFunction2D} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate.
 * @param {number} cellY - The y-coordinate.
 * @returns {number} - The smoothed height value.
 */
const smoothHeight = (noise: NoiseFunction2D, cellX: number, cellY: number) => {
  const scale = NOISE_SCALE;
  const noiseAt = (dx: number, dy: number) => noise(dx / scale, dy / scale);

  const sides =
    (noiseAt(cellX - 1, cellY) +
      noiseAt(cellX + 1, cellY) +
      noiseAt(cellX, cellY - 1) +
      noiseAt(cellX, cellY + 1)) /
    8;

  const center = noiseAt(cellX, cellY) / 4;

  return sides + center;
};

/**
 * Calculates the terrain height of a cell based on noise values.
 * The noise value is scaled by NOISE_SCALE and then adjusted to fit within the range defined by TERRAIN_SCALE.
 * +1 is added to remove negative values.
 *
 * Higher terrain: increase the terrain scale.
 * Lower terrain: decrease the terrain scale.
 *
 * @param {NoiseFunction2D} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate of the cell.
 * @param {number} cellY - The y-coordinate of the cell.
 * @returns {number} - The calculated terrain height for the cell.
 */
export const getTerrainHeight = (
  noise: NoiseFunction2D,
  cellX: number,
  cellY: number
) => {
  const smoothedNoiseValue = smoothHeight(noise, cellX, cellY);
  let height = Math.round((smoothedNoiseValue + 1) * TERRAIN_SCALE);

  // Decrease the base height to lower the overall terrain
  height += 18;

  // Adjust height based on terrain thresholds
  // if (height < Terrain.WATER1) height = Terrain.WATER1; // Removed WATER1
  if (height === Terrain.RESERVED) height = Terrain.SAND1;
  else height += 10;

  return height;
};

/**
 * Generates simplex noise based on a given seed.
 * @param {string} seed - The seed for the noise generator.
 * @returns {NoiseFunction2D} - The noise generator instance.
 */
export const generateNoise = (seed: string) => createNoise2D(alea(seed));
