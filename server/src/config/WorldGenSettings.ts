import alea from "alea";
import { createNoise2D, NoiseFunction2D as Noise } from "simplex-noise";
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
 * Number of cells near the edge where the transition will start to smooth.
 * @constant {number}
 */
export const EDGE_TRANSITION_WIDTH = 5;

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

  // Retrieve the noise values for the adjacent cells
  const sides = [
    noiseAt(cellX - 1, cellY),  // Left cell
    noiseAt(cellX + 1, cellY),  // Right cell
    noiseAt(cellX, cellY - 1),  // Top cell
    noiseAt(cellX, cellY + 1),  // Bottom cell
    noiseAt(cellX, cellY) / 4   // Current cell (weighted)
  ];

  // Calculate the average height by combining the surrounding values
  return (sides[0] + sides[1] + sides[2] + sides[3]) / 8 + sides[4];
};

/**
 * Applies a gradual transition between terrain types from SAND1 to LAND3 for edge tiles.
 *
 * @param {number} distance - Distance from the edge.
 * @param {number} maxDistance - The maximum transition distance.
 * @param {number} terrainHeight - The calculated terrain height based on noise.
 * @returns {number} - The adjusted terrain height with edge smoothing.
 */
const smoothWorldEdge = (distance: number, maxDistance: number, terrainHeight: number) => {
  const blendFactor = distance / maxDistance;
  const terrainTypes = [Terrain.SAND1, Terrain.SAND2, Terrain.LAND1, Terrain.LAND2];

  // Calculate the terrain index once, floor the result
  const terrainIndex = Math.min(
    (blendFactor * terrainTypes.length) >> 0,
    terrainTypes.length - 1
  );

  // Get the target terrain type based on the blend factor.
  const targetTerrain = terrainTypes[terrainIndex];

  // Randomly select one of the edge terrain types
  const edgeTerrain = Math.random() < 0.5 ? targetTerrain : terrainTypes[Math.floor(Math.random() * 3)];
  return Math.round(edgeTerrain * (1 - blendFactor) + terrainHeight * blendFactor);
};

/**
 * Calculates the terrain height of a cell based on noise values, with a smooth transition near the edges.
 *
 * @param {Noise} noise - The noise generator instance.
 * @param {number} cellX - The x-coordinate of the cell.
 * @param {number} cellY - The y-coordinate of the cell.
 * @returns {number} - The calculated terrain height for the cell.
 */
export const getTerrainHeight = (noise: Noise, cellX: number, cellY: number) => {
  const smoothHeightNoise = smoothHeight(noise, cellX, cellY);
  let height = Math.round((smoothHeightNoise + 1) * TERRAIN_SCALE);

  // Decrease the base height to lower the overall terrain
  height += 18;

  // Apply world edge smoothing if the cell is within EDGE_TRANSITION_WIDTH distance from the edge
  const edgeXDistance = Math.min(cellX, WORLD_SIZE[0] - 1 - cellX);
  const edgeYDistance = Math.min(cellY, WORLD_SIZE[1] - 1 - cellY);
  const minEdgeDistance = Math.min(edgeXDistance, edgeYDistance);

  if (minEdgeDistance <= EDGE_TRANSITION_WIDTH) 
    height = smoothWorldEdge(minEdgeDistance, EDGE_TRANSITION_WIDTH, height);
  
  else if (height === Terrain.RESERVED) height = Terrain.SAND1;
  else height += 10;

  return height;
};

/**
 * Generates simplex noise based on a given seed.
 * @param {string} seed - The seed for the noise generator.
 * @returns {Noise} - The noise generator instance.
 */
export const generateNoise = (seed: string) => createNoise2D(alea(seed));
