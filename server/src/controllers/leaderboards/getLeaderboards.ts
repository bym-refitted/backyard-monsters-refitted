import { Status } from "../../enums/StatusCodes";
import { ORMContext, redisClient } from "../../server";
import { KoaController } from "../../utils/KoaController";

/**
 * Time-to-live (TTL) for leaderboard cache in Redis.
 * Two hours (7200 seconds).
 */
export const LB_CACHE_TTL = 7200;

/**
 * Controller to handle the retrieval of leaderboards for a specific world.
 * 
 * First checks if the leaderboard data is cached in Redis.
 * If not, it queries the database for the leaderboard data,
 * caches the result in Redis, and then returns the data to the client.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getLeaderboards: KoaController = async (ctx) => {
  const { worldid } = ctx.query;

  if (!worldid) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "worldId is required" };
    return;
  }

  try {
    const cacheKey = `leaderboards_${worldid}`;
    const cachedData = await redisClient.get(cacheKey);

    if (cachedData) {
      ctx.status = Status.OK;
      ctx.body = { leaderboard: JSON.parse(cachedData) };
      return;
    }

    const leaderboard = await ORMContext.em.getConnection().execute(
      `
            SELECT u.username, u.discord_tag, sub.outpost_count 
            FROM bym.user u
            JOIN (
                SELECT s.userid, COUNT(*) AS outpost_count
                FROM bym.save s 
                WHERE s.type = 'outpost' AND s.worldid = ?
                GROUP BY s.userid
            ) AS sub ON u.userid = sub.userid
            ORDER BY sub.outpost_count DESC
            LIMIT 25
        `,
      [worldid]
    );

    await redisClient.setEx(cacheKey, LB_CACHE_TTL, JSON.stringify(leaderboard));

    ctx.status = Status.OK;
    ctx.body = { leaderboard };
  } catch (error) {
    console.error("Error fetching leaderboard:", error);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "Failed to retrieve leaderboard data" };
  }
};
