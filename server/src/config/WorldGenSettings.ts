import { MapRoom2 } from "../enums/MapRoom";

// =============================================================================
// Map Room 2 - World Generation Configuration
// =============================================================================

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

// =============================================================================
// Map Room 3 - World Generation Configuration
// =============================================================================

/**
 * The seed for cell generation. Changing this will produce a different cell layout.
 * @constant {string}
 */
export const CELL_SEED = "maproom3-cells";

/**
 * The scale factor for placement noise. This determines how clustered cells are.
 * Lower values = more scattered, higher values = larger clusters
 * @constant {number}
 */
export const PLACEMENT_NOISE_SCALE = 5;

/**
 * Threshold for placing cells. Only cells with placement noise above this value get cells.
 * Range: -1 to 1. Higher values = fewer cells, lower values = more cells
 * @constant {number}
 */
export const PLACEMENT_THRESHOLD = 0.45;

/**
 * Number of cells from the map edge where cells will not be placed.
 * @constant {number}
 */
export const CELL_EDGE = 1;

/**
 * Minimum altitude value for cells (corresponds to clover01.png)
 * @constant {number}
 */
export const MIN_CELL_ALTITUDE = 32;

/**
 * Maximum altitude value for cells (corresponds to spiky07.png)
 * @constant {number}
 */
export const MAX_CELL_ALTITUDE = 79;

/**
 * Seed for stronghold placement randomization
 * @constant {string}
 */
export const STRONGHOLD_SEED = "maproom3-strongholds";

/**
 * Grid size for stronghold placement. One stronghold per grid cell.
 * Smaller value = more strongholds. Higher value = fewer strongholds.
 * @constant {number}
 */
export const STRONGHOLD_GRID_SIZE = 24;

/**
 * Maximum random jitter for stronghold positions within their grid cell.
 * Adds randomness to break up the grid pattern while maintaining minimum spacing.
 * @constant {number}
 */
export const STRONGHOLD_JITTER = 8;

/**
 * Minimum distance between resource outposts and strongholds
 * @constant {number}
 */
export const MIN_RESOURCE_STRONGHOLD_DISTANCE = 3;

/**
 * Seed for resource outpost placement randomization
 * @constant {string}
 */
export const RESOURCE_SEED = "maproom3-resources-v2";

/**
 * Grid size for resource outpost placement. One resource per grid cell.
 * Smaller value = more resources. Higher value = fewer resource outposts.
 * @constant {number}
 */
export const RESOURCE_GRID_SIZE = 5;

/**
 * Maximum random jitter for resource outpost positions within their grid cell.
 * Adds randomness to break up the grid pattern while maintaining minimum spacing.
 * @constant {number}
 */
export const RESOURCE_JITTER = 2;

/**
 * Seed for tribe outpost placement randomization
 * @constant {string}
 */
export const TRIBE_OUTPOST_SEED = "maproom3-tribes";
