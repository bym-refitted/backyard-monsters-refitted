import { createHash } from "crypto";
import { brotliCompress, constants, gzip } from "zlib";
import { promisify } from "util";

import { MapRoom2 } from "../../../enums/MapRoom.js";
import {
  EDGE_TRANSITION_WIDTH,
  NOISE_SCALE,
  TERRAIN_SCALE,
} from "../../../config/MapRoom2Config.js";
import { generateNoise, getTerrainHeight } from "./generateMap.js";

export interface TerrainMap {
  raw: Buffer;
  brotli: Buffer;
  gzip: Buffer;
  etag: string;
}

const compressBrotli = promisify(brotliCompress);
const compressGzip = promisify(gzip);

/**
 * Fingerprint of the terrain generation parameters, folded into an ETag.
 */
const TERRAIN_PARAMS_HASH = createHash("sha1")
  .update(`${NOISE_SCALE}:${TERRAIN_SCALE}:${EDGE_TRANSITION_WIDTH}:${MapRoom2.WIDTH}x${MapRoom2.HEIGHT}`)
  .digest("hex")
  .slice(0, 8);

/**
 * Generates the full terrain height map for a world.
 *
 * One byte per cell, indexed x * MapRoom2.HEIGHT + y. Heights are integers
 * well inside a byte, so no scaling is applied.
 *
 * @param {string} worldid - The world to generate for. Doubles as the noise seed.
 * @returns {Promise<TerrainMap>} The raw bytes, brotli and gzip copies, and an ETag.
 */
const buildTerrainMap = async (worldid: string): Promise<TerrainMap> => {
  const noise = generateNoise(worldid);
  const raw = Buffer.alloc(MapRoom2.WIDTH * MapRoom2.HEIGHT);

  for (let x = 0; x < MapRoom2.WIDTH; x++)
    for (let y = 0; y < MapRoom2.HEIGHT; y++)
      raw[x * MapRoom2.HEIGHT + y] = getTerrainHeight(noise, x, y);


  const [brotli, gzip] = await Promise.all([
    compressBrotli(raw, { params: { [constants.BROTLI_PARAM_QUALITY]: 11 } }),
    compressGzip(raw, { level: 9 }),
  ]);

  const etag = `"terrain-${TERRAIN_PARAMS_HASH}-${worldid}"`;

  return { raw, brotli, gzip, etag };
};


/**
 * Cached per world for the process lifetime, keyed by world id.
 */
const terrainCache = new Map<string, Promise<TerrainMap>>();

/**
 * Returns the terrain height map for a world, generating it on first use.
 *
 * Deterministic from the world id, so the result never expires and is held for
 * the process lifetime.
 *
 * @param {string} worldid - The world to fetch terrain for.
 * @returns {Promise<TerrainMap>} The cached terrain map.
 */
export const getTerrainMap = (worldid: string): Promise<TerrainMap> => {
  let terrain = terrainCache.get(worldid);

  if (!terrain) {
    terrain = buildTerrainMap(worldid);
    terrainCache.set(worldid, terrain);
  }

  return terrain;
};
