import z from "zod";
import type { KoaController } from "../../utils/KoaController.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { InfernoMaproom } from "../../models/infernomaproom.model.js";
import { Maproom } from "../../models/maproom.model.js";
import { postgres } from "../../server.js";
import { BaseType } from "../../enums/Base.js";
import { findInfernoNeighbours } from "../../services/maproom/inferno/findInfernoNeighbours.js";
import { findOverworldNeighbours } from "../../services/maproom/v1/findOverworldNeighbours.js";
import { updateNeighbourData } from "../../services/maproom/updateNeighbourData.js";

type NeighbourCache = { neighborsLastCalculated?: Date; neighbors: unknown[] };

const GetNeighboursSchema = z.object({ type: z.string().optional() });

/** Full cache TTL once >= 10 neighbours are found. */
const CACHE_VALIDITY_HOURS = 24 * 7 * 2;

/** Retry interval when the cached list has fewer than 10 neighbours. */
const RETRY_CACHE_MINUTES = 30;

/**
 * Controller to get neighbours for PvP matchmaking.
 * Branches on the type request body param:
 * 
 * 1. inferno - Inferno map room neighbours (cached, level-ranged, cross-world)
 * 2. absent/other - MR1 overworld neighbours (cached, level-ranged, global)
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
 * Serves the cached neighbour list if fresh; otherwise re-runs the search.
 * Uses a short 30-minute retry window when fewer than 10 neighbours are cached,
 * and the full 2-week TTL once the list is healthy.
 *
 * @param {Context} ctx - Koa context containing the authenticated user
 * @returns {Promise<void>} - Sets response body with inferno neighbour data
 */
const getInfernoNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save", "infernosave"]);

  const infernoMaproom = await postgres.em.findOne(InfernoMaproom, { userid: user.userid });

  if (!infernoMaproom) throw new Error("Inferno maproom not found.");

  const currentDate = new Date();
  const cacheExpiry = new Date(currentDate.getTime() - CACHE_VALIDITY_HOURS * 60 * 60 * 1000);
  const retryExpiry = new Date(currentDate.getTime() - RETRY_CACHE_MINUTES * 60 * 1000);

  const getNewNeighbours = needsNewNeighbours(infernoMaproom, cacheExpiry, retryExpiry);

  if (getNewNeighbours) {
    const foundNeighbours = await findInfernoNeighbours(user);

    // Preserve previous attack data on attackers who may have attacked before defender seeded
    infernoMaproom.neighbors = foundNeighbours.map((newNeighbor) => {
      const existing = infernoMaproom.neighbors.find((old) => old.userid === newNeighbor.userid);
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

    infernoMaproom.neighborsLastCalculated = currentDate;
    postgres.em.persist(infernoMaproom);
    await postgres.em.flush();
  }

  const neighbours = await updateNeighbourData(infernoMaproom.neighbors, BaseType.INFERNO);

  ctx.status = Status.OK;
  ctx.body = { error: 0, wmbases: [], bases: neighbours };
};

/**
 * Handles neighbour lookups for the MR1 Overworld Map Room.
 *
 * Serves the cached neighbour list if fresh; otherwise re-runs the search.
 * Uses a short 30-minute retry window when fewer than 10 neighbours are cached,
 * and the full 2-week TTL once the list is healthy.
 *
 * @param {Context} ctx - Koa context containing the authenticated user
 * @returns {Promise<void>} - Sets response body with overworld neighbour data
 */
const getOverworldNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const save = user.save;

  if (!save) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, bases: [] };
    return;
  }

  let maproom = await postgres.em.findOne(Maproom, { userid: user.userid });

  // Initial Map Room 1 creation
  if (!maproom) maproom = await Maproom.setupMapRoomData(postgres.em, user);

  const currentDate = new Date();
  const cacheExpiry = new Date(currentDate.getTime() - CACHE_VALIDITY_HOURS * 60 * 60 * 1000);
  const retryExpiry = new Date(currentDate.getTime() - RETRY_CACHE_MINUTES * 60 * 1000);

  const getNewNeighbours = needsNewNeighbours(maproom, cacheExpiry, retryExpiry);

  if (getNewNeighbours) {
    maproom.neighbors = await findOverworldNeighbours(user, save);

    maproom.neighborsLastCalculated = currentDate;
    postgres.em.persist(maproom);
    await postgres.em.flush();
  }

  const neighbours = await updateNeighbourData(maproom.neighbors, BaseType.MAIN, user.userid);

  ctx.status = Status.OK;
  ctx.body = { error: 0, wmbases: [], bases: neighbours };
};

/**
 * Determines whether a new neighbour search should be run.
 *
 * Returns true immediately if no search has ever been run. Otherwise applies
 * a short retry TTL when the cached list is thin (< 10), or the full cache TTL
 * when the list is healthy (>= 10).
 *
 * @param {NeighbourCache} cache - The maproom record holding the neighbour list and last-calculated timestamp
 * @param {Date} cacheExpiry - Cutoff date for the full 2-week TTL (now minus 2 weeks)
 * @param {Date} retryExpiry - Cutoff date for the short retry TTL (now minus 30 minutes)
 * @returns {boolean} - True if a new search should be run
 */
const needsNewNeighbours = (cache: NeighbourCache, cacheExpiry: Date, retryExpiry: Date) => {
  if (!cache.neighborsLastCalculated) return true;
  
  if (cache.neighbors.length < 10) return cache.neighborsLastCalculated < retryExpiry;

  return cache.neighborsLastCalculated < cacheExpiry;
};
