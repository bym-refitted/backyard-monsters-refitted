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
 * The Map Room version a world runs, from the cached world list.
 *
 * A world's version is fixed at creation and the cache is dropped whenever one is
 * created, so this never needs to reach the database on a warm cache.
 *
 * Callers hold the world of a player who may not be in one at all, so they narrow
 * that away first - each has its own error for it - and this takes a world id it can
 * rely on.
 *
 * @param {string} worldid - The world to look up.
 * @returns {Promise<number | undefined>} Its map version, or undefined when unknown.
 */
export const getWorldMapVersion = async (worldid: string): Promise<number | undefined> => {
  const worlds = await getCachedWorlds();

  return worlds.find((world) => world.uuid === worldid)?.map_version;
};

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
