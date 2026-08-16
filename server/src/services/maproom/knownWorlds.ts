import { World } from "../../models/world.model.js";
import { postgres, redis } from "../../server.js";

export const WORLDS_CACHE_TTL = 7200;

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
 * Checks a caller-supplied world id against the known worlds.
 *
 * @param {string | string[] | undefined} worldid - The world id supplied by the caller.
 * @returns {Promise<boolean>} True when the world exists.
 */
export const isKnownWorld = async (worldid: string | string[] | undefined): Promise<boolean> => {
  if (typeof worldid !== "string" || !worldid) return false;

  const worlds = await getCachedWorlds();

  return worlds.some((world) => world.uuid === worldid);
};
