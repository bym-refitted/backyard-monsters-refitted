import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import {
  InfernoMaproom,
  NeighborData,
} from "../../../models/infernomaproom.model";
import { ORMContext } from "../../../server";
import { BaseType } from "../../../enums/Base";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { errorLog } from "../../../utils/logger";

interface NeighborResponse extends NeighborData {
  type: BaseType.INFERNO;
  wm: number;
  friend: number;
  pic: string;
  basename: string;
  saved: Date;
  attackpermitted: number;
}

/**
 * Cache validity period for inferno neighbors.
 * This is set to 4 weeks.
 */
const CACHE_VALIDITY_HOURS = 24 * 7 * 4;

/**
 * Controller to get inferno neighbours for PvP matchmaking.
 *
 * This system returns cached same-world inferno players within the appropriate level range (±7 levels).
 * Neighbors are calculated once and cached in the inferno_maproom table, then retrieved from cache
 * on subsequent requests. Cache is refreshed when it's older than 4 weeks or doesn't exist.
 * Uses the existing MapRoom v2 world system for world-based neighbor selection.
 *
 * @param {Context} ctx - Koa context object containing authenticated user and request/response
 * @returns {Promise<void>} - Sets response body with neighbor data or error
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

    // Check if we need to fetch new neighbors
    const isCacheExpired =
      !infernoMaproom.neighborsLastCalculated ||
      infernoMaproom.neighborsLastCalculated < cacheExpiry ||
      !infernoMaproom.neighbors.length;

    if (isCacheExpired) {
      const foundNeighbors = await findNeighbours(user);
      infernoMaproom.neighbors = foundNeighbors;
      infernoMaproom.neighborsLastCalculated = currentDate;

      await ORMContext.em.persistAndFlush(infernoMaproom);
    }

    const neighbours: NeighborResponse[] = infernoMaproom.neighbors.map(
      (neighbor) => ({
        ...neighbor,
        type: BaseType.INFERNO,
        wm: 0,
        friend: 0,
        pic: neighbor.pic_square || "",
        basename: `${neighbor.username}`,
        saved: neighbor.lastupdateAt,
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
 * Calculate neighbors for a user and return data suitable for caching.
 *
 * This function finds same-world inferno players within a specified level range
 * and returns their essential data for caching in the inferno_maproom table.
 *
 * @param {User} user - The authenticated user to find neighbors for
 * @returns {Promise<NeighborData[]>} - Array of neighbor data suitable for caching
 */
const findNeighbours = async (user: User): Promise<NeighborData[]> => {
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

  // Fetch user data for all valid neighbours in one query
  const neighbourUsers = await ORMContext.em.find(User, {
    userid: { $in: Array.from(userIds) },
  });

  const users = new Map<number, User>();
  neighbourUsers.forEach((user) => users.set(user.userid, user));

  // Build cached neighbor data
  const cachedNeighbors: NeighborData[] = [];

  for (const neighbor of validNeighbours) {
    const neighbourUser = users.get(neighbor.save.userid);

    if (neighbourUser) {
      cachedNeighbors.push({
        userid: neighbor.save.userid,
        baseid: neighbor.save.baseid,
        level: neighbor.level,
        username: neighbourUser.username,
        pic_square: neighbourUser.pic_square || "",
        lastupdateAt: neighbor.save.lastupdateAt,
      });
    }
  }

  return cachedNeighbors;
};
