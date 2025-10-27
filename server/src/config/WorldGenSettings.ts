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
 * Grid spacing between strongholds (in cells)
 * @constant {number}
 */
export const STRONGHOLD_GRID_SPACING = 30;

/**
 * Offset from the edge for the first stronghold placement
 * @constant {number}
 */
export const STRONGHOLD_GRID_OFFSET = 10;
