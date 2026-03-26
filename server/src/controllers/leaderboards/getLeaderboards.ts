import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { EnumYardType } from "../../enums/EnumYardType.js";
import { postgres, redis } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";

interface MR2Leaderboard {
  username: string;
  discord_tag: string | null;
  outpost_count: string;
}

interface MR3Leaderboard {
  username: string;
  discord_tag: string | null;
  stronghold_count: string;
  outpost_count: string;
}

/**
 * Time-to-live (TTL) for leaderboard cache in Redis.
 * Two hours (7200 seconds).
 */
export const LB_CACHE_TTL = 7200;

/**
 * Controller to handle the retrieval of leaderboards for a specific world.
 *
 * Supports Map Room 2 and Map Room 3 via the `mapversion` query parameter.
 * - MR2: ranks players by outpost count from the save table.
 * - MR3: ranks players by stronghold and resource outpost count from world_map_cell.
 *
 * First checks if the leaderboard data is cached in Redis.
 * If not, it queries the database for the leaderboard data,
 * caches the result in Redis, and then returns the data to the client.
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getLeaderboards: KoaController = async (ctx) => {
  const { worldid, mapversion } = ctx.query;

  if (!worldid || !mapversion) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "worldid and mapversion are required" };
    return;
  }

  const version = Number(mapversion);

  try {
    const cacheKey = `leaderboards_${worldid}_v${version}`;
    const cachedData = await redis.get(cacheKey);

    if (cachedData) {
      ctx.status = Status.OK;
      ctx.body = { leaderboard: JSON.parse(cachedData) };
      return;
    }

    let leaderboard: MR2Leaderboard[] | MR3Leaderboard[];

    if (version === MapRoomVersion.V3) {
      leaderboard = await postgres.em.getConnection().execute<MR3Leaderboard[]>(
        `
          SELECT
            u.username,
            u.discord_tag,
            COUNT(*) FILTER (WHERE wmc.base_type = ?) AS stronghold_count,
            COUNT(*) FILTER (WHERE wmc.base_type = ?) AS outpost_count
          FROM bym.world_map_cell wmc
          JOIN bym.user u ON u.userid = wmc.uid
          WHERE wmc.world_id = ?
            AND wmc.map_version = ?
            AND wmc.base_type IN (?, ?)
            AND wmc.destroyed_at IS NULL
          GROUP BY u.userid, u.username, u.discord_tag
          ORDER BY (COUNT(*) FILTER (WHERE wmc.base_type = ?) + COUNT(*) FILTER (WHERE wmc.base_type = ?)) DESC
          LIMIT 25
        `,
        [
          EnumYardType.STRONGHOLD,
          EnumYardType.RESOURCE,
          worldid,
          MapRoomVersion.V3,
          EnumYardType.STRONGHOLD,
          EnumYardType.RESOURCE,
          EnumYardType.STRONGHOLD,
          EnumYardType.RESOURCE,
        ],
      );
    } else {
      leaderboard = await postgres.em.getConnection().execute<MR2Leaderboard[]>(
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
        [worldid],
      );
    }

    await redis.setex(cacheKey, LB_CACHE_TTL, JSON.stringify(leaderboard));

    ctx.status = Status.OK;
    ctx.body = { leaderboard };
  } catch (error) {
    console.error("Error fetching leaderboard:", error);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "Failed to retrieve leaderboard data" };
  }
};
