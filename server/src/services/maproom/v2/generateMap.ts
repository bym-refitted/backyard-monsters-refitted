import alea from "alea";

import { createNoise2D, NoiseFunction2D as Noise } from "simplex-noise";
import { MapRoom2, Terrain } from "../../../enums/MapRoom";

import {
  NOISE_SCALE,
  WORLD_SIZE,
  EDGE_TRANSITION_WIDTH,
  TERRAIN_SCALE,
} from "../../../config/WorldGenSettings";

/**
 * Generates simplex noise based on a given seed.
 * 
 * @param {string} seed - The seed for the noise generator.
 * @returns {Noise} - The noise generator instance.
 */
export const generateNoise = (seed: string) => createNoise2D(alea(seed));

/**
 * Calculates the terrain height of a cell based on noise values, with a smooth transition near the edges.
 *
 * @param {Noise} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate of the cell.
 * @param {number} cellY - The y-coordinate of the cell.
 * @returns {number} - The calculated terrain height for the cell.
 */
export const getTerrainHeight = (noise: Noise, cellX: number, cellY: number) => {
  // The distance of x from the far edge of the world
  const distanceXFromLimit = WORLD_SIZE[0] - 1 - cellX;
  const distanceYFromLimit = WORLD_SIZE[1] - 1 - cellY;

  // Apply world edge smoothing if the cell is within EDGE_TRANSITION_WIDTH distance from the edge
  let edgeXDistance = Math.min(cellX, distanceXFromLimit);
  let edgeYDistance = Math.min(cellY, distanceYFromLimit);

  // Get the noise value for the cell
  let smoothHeightNoise = smoothHeight(noise, cellX, cellY);

  if (edgeYDistance <= EDGE_TRANSITION_WIDTH) {
    
    if (distanceYFromLimit > cellY) {
      edgeYDistance = edgeYDistance * -1;
    }
    // Get the noise value for the top edge of the transition zone
    const smoothTopNoiseEdge = smoothHeight(
      noise,
      cellX,
      EDGE_TRANSITION_WIDTH
    );

    // Get the noise value for the bottom edge (far edge) of the transition zone
    const smoothedBottomNoiseFarEdge = smoothHeight(
      noise,
      cellX,
      WORLD_SIZE[1] - EDGE_TRANSITION_WIDTH - 1
    );

    // Calculate the interpolation factor based on how close we are to the far edge
    const factor = edgeYDistance / EDGE_TRANSITION_WIDTH;

    // Perform linear interpolation (lerp) between the two edge noise values
    const edgeNoiseBlend =
      smoothTopNoiseEdge * (1 - factor) + smoothedBottomNoiseFarEdge * factor;

    // Blend the interpolated edge noise with the original noise value
    smoothHeightNoise = (smoothHeightNoise + edgeNoiseBlend) / 3;
  } else if (edgeXDistance <= EDGE_TRANSITION_WIDTH) {
    if (distanceXFromLimit > cellY) edgeXDistance = edgeXDistance * -1;

    // Get the noise value for the top edge of the transition zone
    const smoothTopNoiseEdge = smoothHeight(
      noise,
      EDGE_TRANSITION_WIDTH,
      cellY
    );

    // Get the noise value for the bottom edge (far edge) of the transition zone
    const smoothedBottomNoiseFarEdge = smoothHeight(
      noise,
      WORLD_SIZE[1] - EDGE_TRANSITION_WIDTH - 1,
      cellY
    );

    // Calculate the interpolation factor based on how close we are to the far edge
    const factor = edgeXDistance / EDGE_TRANSITION_WIDTH;

    // Perform linear interpolation (lerp) between the two edge noise values
    const edgeNoiseBlend =
      smoothTopNoiseEdge * (1 - factor) + smoothedBottomNoiseFarEdge * factor;

    // Blend the interpolated edge noise with the original noise value
    smoothHeightNoise = (smoothHeightNoise + edgeNoiseBlend) / 3;
  }

  let height = Math.round((smoothHeightNoise + 1) * TERRAIN_SCALE);
  height += 18;

  if (height === Terrain.RESERVED) height = Terrain.SAND1;
  else height += 10;

  return height;
};

/**
 * Smooths the height value by averaging the values of the surrounding cells.
 *
 * @param {Noise} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate.
 * @param {number} cellY - The y-coordinate.
 * @returns {number} - The smoothed height value.
 */
const smoothHeight = (noise: Noise, cellX: number, cellY: number) => {
  const scale = NOISE_SCALE;
  const noiseAt = (dx: number, dy: number) => noise(dx / scale, dy / scale);

  const topCellY = cellY - 1 < 0 ? MapRoom2.HEIGHT - cellY - 1 : cellY - 1;
  const rightCellX = cellX - 1 < 0 ? MapRoom2.HEIGHT - cellX - 1 : cellX - 1;
  let currentCell = noiseAt(cellX, cellY) / 4;

  // Retrieve the noise values for the adjacent cells
  const topCell = noiseAt(cellX, topCellY);
  const rightCell = noiseAt(rightCellX, cellY);

  // Calculate the average height by combining the surrounding values
  return (topCell + rightCell) / 4 + currentCell;
};
