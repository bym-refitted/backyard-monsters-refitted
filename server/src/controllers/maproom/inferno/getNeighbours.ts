import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import {
  InfernoMaproom,
  NeighbourData,
} from "../../../models/infernomaproom.model";
import { ORMContext } from "../../../server";
import { BaseType } from "../../../enums/Base";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { errorLog } from "../../../utils/logger";

interface NeighbourResponse extends NeighbourData {
  type: BaseType.INFERNO;
  wm: number;
  friend: number;
  pic: string;
  basename: string;
  saved: Date;
  attackpermitted: number;
}

/**
 * Cache validity period for inferno neighbours.
 * This is set to 4 weeks.
 */
const CACHE_VALIDITY_HOURS = 24 * 7 * 4;

/**
 * Controller to get inferno neighbours for PvP matchmaking.
 *
 * This system returns cached same-world inferno players within the appropriate level range (±7 levels).
 * Neighbours are calculated once and cached in the inferno_maproom table, then retrieved from cache
 * on subsequent requests. Cache is refreshed when it's older than 4 weeks or doesn't exist.
 * Uses the existing MapRoom v2 world system for world-based neighbour selection.
 *
 * @param {Context} ctx - Koa context object containing authenticated user and request/response
 * @returns {Promise<void>} - Sets response body with neighbour data or error
 */
export const getNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save", "infernosave"]);

  try {
    let infernoMaproom = await ORMContext.em.findOne(InfernoMaproom, {
      userid: user.userid,
    });

    const currentDate = new Date();
    const cacheExpiry = new Date(
      currentDate.getTime() - CACHE_VALIDITY_HOURS * 60 * 60 * 1000
    );

    // Check if we need to fetch new neighbours
    const getNewNeighbours = isCacheExpired(infernoMaproom, cacheExpiry);

    if (getNewNeighbours) {
      const foundNeighbours = await findNeighbours(user);
      infernoMaproom.neighbors = foundNeighbours;
      infernoMaproom.neighborsLastCalculated = currentDate;

      await ORMContext.em.persistAndFlush(infernoMaproom);
    }

    const neighbours: NeighbourResponse[] = infernoMaproom.neighbors.map(
      (neighbour) => ({
        ...neighbour,
        type: BaseType.INFERNO,
        wm: 0,
        friend: 0,
        pic: neighbour.pic_square || "",
        basename: `${neighbour.username}`,
        saved: neighbour.lastupdateAt,
        attackpermitted: 1,
      })
    );

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      wmbases: [],
      bases: neighbours,
    };
  } catch (error) {
    errorLog("Error fetching inferno neighbours:", error);
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      wmbases: [],
      bases: [],
    };
  }
};

/**
 * Calculate neighbours for a user and return data suitable for caching.
 *
 * This function finds same-world inferno players within a specified level range
 * and returns their essential data for caching in the inferno_maproom table.
 *
 * @param {User} user - The authenticated user to find neighbours for
 * @returns {Promise<NeighbourData[]>} - Array of neighbour data suitable for caching
 */
const findNeighbours = async (user: User): Promise<NeighbourData[]> => {
  const { infernosave, save } = user;

  if (!save.worldid) return [];

  const userLevel = calculateBaseLevel(
    infernosave.points,
    infernosave.basevalue
  );

  const levelRange = 7;
  const minLevel = Math.max(1, userLevel - levelRange);
  const maxLevel = userLevel + levelRange;

  const validNeighbours: Array<{ save: Save; level: number }> = [];
  const userIds = new Set<number>();

  // Retrieve inferno saves of other users in the same overworld
  const infernoSaves = await ORMContext.em.find(
    Save,
    {
      type: BaseType.INFERNO,
      worldid: infernosave.worldid,
      userid: { $ne: user.userid },
    },
    {
      limit: 150,
      orderBy: { lastupdateAt: "DESC" },
    }
  );

  for (const neighbourSave of infernoSaves) {
    const neighbourLevel = calculateBaseLevel(
      neighbourSave.points,
      neighbourSave.basevalue
    );

    // Only include same-world players within the level range
    if (neighbourLevel >= minLevel && neighbourLevel <= maxLevel) {
      validNeighbours.push({ save: neighbourSave, level: neighbourLevel });
      userIds.add(neighbourSave.userid);

      if (validNeighbours.length >= 25) break;
    }
  }

  // Fetch users for all valid neighbours
  const neighbourUsers = await ORMContext.em.find(User, {
    userid: { $in: Array.from(userIds) },
  });

  const users = new Map<number, User>();
  neighbourUsers.forEach((user) => users.set(user.userid, user));

  const cachedNeighbours: NeighbourData[] = [];

  for (const neighbour of validNeighbours) {
    const neighbourUser = users.get(neighbour.save.userid);

    if (neighbourUser) {
      cachedNeighbours.push({
        userid: neighbour.save.userid,
        baseid: neighbour.save.baseid,
        level: neighbour.level,
        username: neighbourUser.username,
        pic_square: neighbourUser.pic_square || "",
        lastupdateAt: neighbour.save.lastupdateAt,
      });
    }
  }

  return cachedNeighbours;
};

/**
 * Check if the neighbour cache has expired and needs to be refreshed
 *
 * @param {InfernoMaproom} infernoMaproom - The inferno maproom object to check
 * @param {Date} cacheExpiry - The date before which the cache is considered expired
 * @returns {boolean} - True if the cache is expired, false otherwise
 */
const isCacheExpired = (infernoMaproom: InfernoMaproom, cacheExpiry: Date) =>
  !infernoMaproom.neighborsLastCalculated ||
  infernoMaproom.neighborsLastCalculated < cacheExpiry ||
  !infernoMaproom.neighbors.length;
