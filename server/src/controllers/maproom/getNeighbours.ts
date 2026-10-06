import z from "zod";
import type { KoaController } from "../../utils/KoaController.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { Save } from "../../database/models/save.model.js";
import { InfernoMaproom } from "../../database/models/infernomaproom.model.js";
import { Maproom } from "../../database/models/maproom.model.js";
import type { NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { postgres } from "../../server.js";
import { BaseType } from "../../enums/Base.js";
import { refreshNeighbours } from "../../services/maproom/refreshNeighbours.js";
import { getNeighbourIds, toNeighbourData } from "../../services/maproom/neighbours.js";
import { applyAttackHistory } from "../../services/maproom/attackHistory.js";
import { NEIGHBOUR_REFRESH_HOURS, MAX_CLIENT_NEIGHBOURS } from "../../config/NeighbourConfig.js";
import { updateNeighbourData, type UpdateNeighbourData } from "../../services/maproom/updateNeighbourData.js";
import { getFriendIds } from "../../services/friends/friendList.js";
import { calculateBaseLevel } from "../../services/base/calculateBaseLevel.js";
import type { NeighbourData } from "../../types/NeighbourData.js";

type NeighbourCache = { neighborsLastCalculated?: Date; neighbors: unknown[] };

interface NeighbourMap {
  userId: number;
  save: Pick<Save, "points" | "basevalue">;
  maproom: Pick<Maproom | InfernoMaproom, "neighborsLastCalculated">;
  neighbourIds: number[];
  friendIds: Set<number>;
  type: NeighbourAttackType;
}

const GetNeighboursSchema = z.object({ type: z.string().optional() });

const MAPROOM_FIELDS = ["userid", "neighborsLastCalculated"] as const;

/** Retry interval when a map has fewer than 10 neighbours. */
const RETRY_CACHE_MINUTES = 30;

/**
 * Controller to get neighbours for PvP matchmaking.
 * Branches on the type request body param:
 *
 * 1. inferno - Inferno map room neighbours
 * 2. absent/other - MR1 overworld neighbours
 *
 * On both maps a player's neighbours are the players they share a link with, so
 * everyone on their map has them on theirs.
 *
 * @param {Context} ctx - Koa context object containing authenticated user and request/response
 * @returns {Promise<void>} - Sets response body with neighbour data or error
 */
export const getNeighbours: KoaController = async (ctx) => {
  const { type } = GetNeighboursSchema.parse(ctx.request.body);

  if (type === BaseType.INFERNO) {
    return getInfernoNeighbours(ctx);
  } else {
    return getOverworldNeighbours(ctx);
  }
};

/**
 * Handles neighbour lookups for the Inferno Map Room.
 *
 * The Inferno map has no friends or truces, so neither is looked up.
 *
 * @param {Context} ctx - Koa context containing the authenticated user
 * @returns {Promise<void>} - Sets response body with inferno neighbour data
 */
const getInfernoNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  await postgres.em.populate(user, ["infernosave"], { fields: ["infernosave.points", "infernosave.basevalue"] });

  const save = user.infernosave;

  if (!save) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, wmbases: [], bases: [] };
    return;
  }

  const [maproom, neighbourIds] = await Promise.all([
    postgres.em.findOne(InfernoMaproom, { userid: user.userid }, { fields: MAPROOM_FIELDS }),
    getNeighbourIds(user.userid, BaseType.INFERNO),
  ]);

  if (!maproom) throw new Error("Inferno maproom not found.");

  const neighbourMap: NeighbourMap = {
    userId: user.userid,
    save,
    maproom,
    neighbourIds,
    friendIds: new Set(),
    type: BaseType.INFERNO,
  };

  const withHistory = await loadNeighbours(neighbourMap);

  const neighbourUpdate: UpdateNeighbourData = {
    cachedNeighbours: withHistory,
    baseType: BaseType.INFERNO,
    viewerLevel: calculateBaseLevel(save.points, save.basevalue),
  };

  const neighbours = await updateNeighbourData(neighbourUpdate);

  ctx.status = Status.OK;
  ctx.body = { error: 0, wmbases: [], bases: neighbours };
};

/**
 * Handles neighbour lookups for the MR1 Overworld Map Room.
 *
 * @param {Context} ctx - Koa context containing the authenticated user
 * @returns {Promise<void>} - Sets response body with overworld neighbour data
 */
const getOverworldNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"], { fields: ["save.points", "save.basevalue"] });

  const save = user.save;

  if (!save) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, bases: [] };
    return;
  }

  const [existingMaproom, friendIds, neighbourIds] = await Promise.all([
    postgres.em.findOne(Maproom, { userid: user.userid }, { fields: MAPROOM_FIELDS }),
    getFriendIds(user.userid),
    getNeighbourIds(user.userid, BaseType.MAIN),
  ]);

  // Initial Map Room 1 creation
  const maproom = existingMaproom ?? await Maproom.setupMapRoomData(postgres.em, user);

  const neighbourMap: NeighbourMap = {
    userId: user.userid,
    save,
    maproom,
    neighbourIds,
    friendIds,
    type: BaseType.MAIN,
  };

  const withHistory = await loadNeighbours(neighbourMap);

  const neighbourUpdate: UpdateNeighbourData = {
    cachedNeighbours: withHistory,
    baseType: BaseType.MAIN,
    viewerLevel: calculateBaseLevel(save.points, save.basevalue),
    currentUserId: user.userid,
    friends: friendIds,
  };

  const neighbours = await updateNeighbourData(neighbourUpdate);

  ctx.status = Status.OK;
  ctx.body = { error: 0, wmbases: [], bases: neighbours };
};

/**
 * Builds a player's neighbour list for either map, with the attack history
 * between them filled in.
 *
 * The map is tidied and topped up once a day, or every 30 minutes while it has
 * fewer than 10 neighbours.
 *
 * @param {NeighbourMap} options - The map being read
 * @param {number} options.userId - The player reading their map
 * @param {Pick<Save, "points" | "basevalue">} options.save - Their save on that map, for their level
 * @param {Pick<Maproom | InfernoMaproom, "neighborsLastCalculated">} options.maproom - Where the last refresh is recorded
 * @param {number[]} options.neighbourIds - Everyone on their map now
 * @param {Set<number>} options.friendIds - Their friends
 * @param {NeighbourAttackType} options.type - Which map is being read
 * @returns {Promise<NeighbourData[]>} Their neighbours, ready for updateNeighbourData
 */
const loadNeighbours = async ({ userId, save, maproom, neighbourIds, friendIds, type }: NeighbourMap): Promise<NeighbourData[]> => {
  const currentDate = new Date();
  const refreshExpiry = new Date(currentDate.getTime() - NEIGHBOUR_REFRESH_HOURS * 60 * 60 * 1000);
  const retryExpiry = new Date(currentDate.getTime() - RETRY_CACHE_MINUTES * 60 * 1000);

  const cache = { neighborsLastCalculated: maproom.neighborsLastCalculated, neighbors: neighbourIds };

  const getNewNeighbours = needsNewNeighbours(cache, refreshExpiry, retryExpiry);

  if (getNewNeighbours) {
    neighbourIds = await refreshNeighbours({ userId, save, neighbourIds, friendIds, type });

    maproom.neighborsLastCalculated = currentDate;
    postgres.em.persist(maproom);
    await postgres.em.flush();
  }

  const userIds = neighbourIds.slice(0, MAX_CLIENT_NEIGHBOURS);
  const neighbourData = toNeighbourData(userIds);

  return applyAttackHistory(userId, neighbourData, type);
};

/**
 * Determines whether a map is due a refresh.
 *
 * Returns true immediately if it has never had one. Otherwise applies a short
 * retry interval when the map is thin (< 10), or the full refresh interval
 * when it is healthy (>= 10).
 *
 * @param {NeighbourCache} cache - The neighbour list and when it was last refreshed
 * @param {Date} cacheExpiry - Cutoff date for the full refresh interval
 * @param {Date} retryExpiry - Cutoff date for the short retry interval (now minus 30 minutes)
 * @returns {boolean} - True if a refresh should be run
 */
const needsNewNeighbours = (cache: NeighbourCache, cacheExpiry: Date, retryExpiry: Date) => {
  if (!cache.neighborsLastCalculated) return true;

  if (cache.neighbors.length < 10) return cache.neighborsLastCalculated < retryExpiry;

  return cache.neighborsLastCalculated < cacheExpiry;
};
