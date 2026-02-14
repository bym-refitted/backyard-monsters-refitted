import { EnumYardType } from "../enums/EnumYardType.js";
import { strongholds } from "../data/tribes/v3/strongholds.js";
import { resources } from "../data/tribes/v3/resources.js";
import { defenders } from "../data/tribes/v3/defenders.js";
import { kozu } from "../data/tribes/v3/outposts/kozu.js";
import { legionnaire } from "../data/tribes/v3/outposts/legionnaire.js";
import { abunakki } from "../data/tribes/v3/outposts/abunakki.js";
import { dreadnaut } from "../data/tribes/v3/outposts/dreadnaut.js";

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
export const STRONGHOLD_GRID_SIZE = 18;

/**
 * Maximum random jitter for stronghold positions within their grid cell.
 * Adds randomness to break up the grid pattern while maintaining minimum spacing.
 * @constant {number}
 */
export const STRONGHOLD_JITTER = 8;

/**
 * Seed for resource outpost placement randomization
 * @constant {string}
 */
export const RESOURCE_SEED = "maproom3-resources-v2";

/**
 * Seed for tribe outpost placement randomization
 * @constant {string}
 */
export const TRIBE_OUTPOST_SEED = "maproom3-tribes";

/** Available levels per structure type. */
export const STRUCTURE_LEVELS: Record<number, number[]> = {
  [EnumYardType.STRONGHOLD]: [30, 40, 50],
  [EnumYardType.RESOURCE]: [10, 20, 30, 40, 50],
  [EnumYardType.OUTPOST]: [45, 50],
};

/** Attack range per structure type and level. */
export const STRUCTURE_RANGE: Record<number, Record<number, number>> = {
  [EnumYardType.STRONGHOLD]: { 30: 10, 40: 15, 50: 20 },
  [EnumYardType.RESOURCE]: { 10: 2, 20: 3, 30: 4, 40: 5, 50: 6 },
};

/** Save data templates per structure type and level. */
export const STRUCTURE_SAVES = {
  [EnumYardType.STRONGHOLD]: strongholds,
  [EnumYardType.RESOURCE]: resources,
  [EnumYardType.FORTIFICATION]: defenders,
};

/** Save data templates for tribe outposts, keyed by tribe index then level. */
export const OUTPOST_SAVES = {
  0: legionnaire,
  1: kozu,
  2: abunakki,
  3: dreadnaut,
};

/** Defender levels per parent structure type and level. */
export const DEFENDER_LEVELS = {
  [EnumYardType.PLAYER]: { 0: [5, 5, 10, 10, 15, 20] },

  [EnumYardType.RESOURCE]: {
    10: [5, 5, 10, 10, 15, 20],
    20: [10, 10, 15, 15, 20, 25],
    30: [20, 20, 25, 25, 30, 35],
    40: [30, 30, 35, 35, 40, 45],
    50: [40, 40, 45, 45, 50, 50],
  },

  [EnumYardType.STRONGHOLD]: {
    30: [20, 20, 25, 25, 30, 35],
    40: [30, 30, 35, 35, 40, 45],
    50: [40, 40, 45, 45, 50, 50],
  },
};
