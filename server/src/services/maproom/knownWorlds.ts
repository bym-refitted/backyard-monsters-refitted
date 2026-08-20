import { MapRoomVersion } from "../../enums/MapRoom.js";
import { World } from "../../models/world.model.js";
import { postgres, redis } from "../../server.js";

export const WORLDS_CACHE_TTL = 86400;

const WORLDS_CACHE_KEY = "availableWorlds";

/**
 * Returns every world, from Redis when cached and from the database otherwise.
 *
 * @returns {Promise<World[]>} All known worlds.
 */
export const getCachedWorlds = async (): Promise<World[]> => {
  const cached = await redis.get(WORLDS_CACHE_KEY);

  if (cached) return JSON.parse(cached);

  const worlds = await postgres.em.find(World, {});

  await redis.setex(WORLDS_CACHE_KEY, WORLDS_CACHE_TTL, JSON.stringify(worlds));

  return worlds;
};

/**
 * Drops the cached world list.
 *
 * @returns {Promise<number>} Resolves once the key is dropped.
 */
export const invalidateWorldsCache = () => redis.del(WORLDS_CACHE_KEY);

/**
 * Checks a caller-supplied world id against the known worlds.
 *
 * Pass mapVersion on routes that are specific to one map room. World ids are
 * shared across versions, so a route serving MR2 data would otherwise accept an
 * MR3 world id and generate a map for a world that does not have one.
 *
 * @param {string | string[] | undefined} worldid - The world id supplied by the caller.
 * @param {MapRoomVersion} [mapVersion] - Restrict the match to one map room version.
 * @returns {Promise<boolean>} True when the world exists.
 */
export const isKnownWorld = async (worldid: string | string[] | undefined, mapVersion?: MapRoomVersion) => {
  if (typeof worldid !== "string" || !worldid) return false;

  const worlds = await getCachedWorlds();

  return worlds.some(
    (world) =>
      world.uuid === worldid && (mapVersion === undefined || world.map_version === mapVersion),
  );
};
