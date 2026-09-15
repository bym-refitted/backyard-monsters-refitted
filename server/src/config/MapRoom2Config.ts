import { MapRoom2 } from "../enums/MapRoom.js";

/**
 * Represents the size of Map Room 2 world map.
 * @constant {number[]}
 */
export const WORLD_SIZE = [MapRoom2.HEIGHT, MapRoom2.WIDTH];

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
export const EDGE_TRANSITION_WIDTH = 3;

/**
 * The most of any one resource a Map Room 2 player can store
 * @constant {number}
 */
export const MAX_RESOURCE_CAPACITY = 7_046_100_000;