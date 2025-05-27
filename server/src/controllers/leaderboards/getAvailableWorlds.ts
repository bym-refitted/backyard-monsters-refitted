import { Status } from "../../enums/StatusCodes";
import { World } from "../../models/world.model";
import { ORMContext, redisClient } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { LB_CACHE_TTL } from "./getLeaderboards";

/**
 * Controller to handle the retrieval of available worlds.
 *
 * First checks if the world data is cached in Redis.
 * If not, it queries the database for the world data,
 * caches the result in Redis, and then returns the data to the client.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getAvailableWorlds: KoaController = async (ctx) => {
  const cacheKey = "availableWorlds";
  let worlds: World[] = [];

  const cachedWorlds = await redisClient.get(cacheKey);

  if (cachedWorlds) {
    worlds = JSON.parse(cachedWorlds);
  } else {
    worlds = await ORMContext.em.find(World, {});
    await redisClient.setEx(cacheKey, LB_CACHE_TTL, JSON.stringify(worlds));
  }

  ctx.status = Status.OK;
  ctx.body = { worlds };
};
