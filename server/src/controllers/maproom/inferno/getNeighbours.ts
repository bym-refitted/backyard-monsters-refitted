import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { InfernoMaproom } from "../../../models/infernomaproom.model";
import { postgres } from "../../../server";
import { BaseType } from "../../../enums/Base";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { damageProtection } from "../../../services/maproom/v2/damageProtection";
import { errorLog } from "../../../utils/logger";
import { AttackPermission } from "../../../enums/MapRoom";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import {
  NeighbourData,
  createNeighbourData,
} from "../../../services/maproom/inferno/createNeighbourData";

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
  await postgres.em.populate(user, ["save", "infernosave"]);

  try {
    if (!user.save.worldid) {
      ctx.status = Status.OK;
      ctx.body = { error: 0, bases: [] };
      return;
    }

    let infernoMaproom = await postgres.em.findOne(InfernoMaproom, {
      userid: user.userid,
    });

    const currentDate = new Date();
    const cacheExpiry = new Date(
      currentDate.getTime() - CACHE_VALIDITY_HOURS * 60 * 60 * 1000
    );

    // Check if we need to fetch new neighbours (cache expired or array empty)
    const getNewNeighbours = isCacheExpired(infernoMaproom, cacheExpiry) || infernoMaproom.neighbors.length === 0;

    if (getNewNeighbours) {
      const foundNeighbours = await findNeighbours(user);

      // Preserve previous attack data on attackers who may have attacked before defender seeded
      const mergedNeighbors = foundNeighbours.map((newNeighbor) => {
        const existing = infernoMaproom.neighbors.find(
          (old) => old.userid === newNeighbor.userid
        );

        if (existing) {
          return {
            ...newNeighbor,
            attacksfrom: existing.attacksfrom || 0,
            attacksto: existing.attacksto || 0,
            retaliatecount: existing.retaliatecount || 0,
          };
        }

        return newNeighbor;
      });

      infernoMaproom.neighbors = mergedNeighbors;
      infernoMaproom.neighborsLastCalculated = currentDate;

      await postgres.em.persistAndFlush(infernoMaproom);
    }

    // Update attack permissions for cached neighbours based on current save state
    const neighbours = await updateNeighbourData(infernoMaproom.neighbors);

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
  const infernoSaves = await postgres.em.find(
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
  const neighbourUsers = await postgres.em.find(User, {
    userid: { $in: Array.from(userIds) },
  });

  const users = new Map<number, User>();
  neighbourUsers.forEach((user) => users.set(user.userid, user));

  const cachedNeighbours: NeighbourData[] = [];

  for (const neighbour of validNeighbours) {
    const neighbourUser = users.get(neighbour.save.userid);
    const { save, level } = neighbour;

    if (neighbourUser) {
      const neighbourData = createNeighbourData(save, neighbourUser, level);
      cachedNeighbours.push(neighbourData);
    }
  }

  return cachedNeighbours;
};

/**
 * Updates and overrides dynamic data which changes frequently between neighbours.
 * This function runs every time getNeighbours controller is called to ensure up-to-date information.
 * Filters out neighbours whose saves no longer exist in the database.
 *
 * @param {NeighbourData[]} cachedNeighbours - The cached neighbour data
 * @returns {Promise<NeighbourData[]>} - Updated neighbour data with current attack permissions
 */
const updateNeighbourData = async (cachedNeighbours: NeighbourData[]) => {
  if (!cachedNeighbours.length) return cachedNeighbours;

  const userIds = cachedNeighbours.map((neighbour) => neighbour.userid);

  const neighbourSaves = await postgres.em.find(Save, {
    type: BaseType.INFERNO,
    userid: { $in: userIds },
  });

  const saveMap = new Map<number, Save>();
  neighbourSaves.forEach((save) => saveMap.set(save.userid, save));

  // Update protection status for all saves
  for (const save of neighbourSaves) await damageProtection(save);

  return cachedNeighbours
    .filter((neighbour) => saveMap.has(neighbour.userid))
    .map((neighbour) => {
      const currentSave = saveMap.get(neighbour.userid);

      // TODO: Add the rest of the cases here for attack permissions
      // e.g. level too low, starting protection, etc
      const currentTime = getCurrentDateTime();
      const isProtected = currentSave.protected > 0 && currentSave.protected > currentTime;
      if (isProtected) {
        neighbour.attackpermitted = AttackPermission.DAMAGE_PROTECTION;
      } else {
        neighbour.attackpermitted = AttackPermission.ATTACKABLE;
      }

      neighbour.level = currentSave.level;
      neighbour.saved = currentSave.savetime;
      neighbour.online = getCurrentDateTime() - currentSave.savetime <= 60;

      return neighbour;
    });
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
  infernoMaproom.neighborsLastCalculated < cacheExpiry;
