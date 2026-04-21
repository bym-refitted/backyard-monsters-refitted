import z from "zod";
import type { KoaController } from "../../../utils/KoaController.js";
import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../models/user.model.js";
import { InfernoMaproom } from "../../../models/infernomaproom.model.js";
import { Maproom } from "../../../models/maproom.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { findInfernoNeighbours } from "../../../services/maproom/inferno/findInfernoNeighbours.js";
import { findOverworldNeighbours } from "../../../services/maproom/v1/findOverworldNeighbours.js";
import { updateNeighbourData } from "../../../services/maproom/updateNeighbourData.js";
const GetNeighboursSchema = z.object({ type: z.string().optional() });

/**
 * Cache validity period for neighbours.
 * This is set to 2 weeks.
 */
const CACHE_VALIDITY_HOURS = 24 * 7 * 2;

/**
 * Controller to get neighbours for PvP matchmaking.
 * Branches on the type request body param:
 * 
 * 1. inferno - Inferno map room neighbours (cached, level-ranged, same world)
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

const getInfernoNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save", "infernosave"]);

  if (!user.save?.worldid) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, bases: [] };
    return;
  }

  const infernoMaproom = await postgres.em.findOne(InfernoMaproom, { userid: user.userid });

  if (!infernoMaproom) throw new Error("Inferno maproom not found.");

  const currentDate = new Date();
  const cacheExpiry = new Date(currentDate.getTime() - CACHE_VALIDITY_HOURS * 60 * 60 * 1000);
  const getNewNeighbours = isCacheExpired(infernoMaproom, cacheExpiry) || infernoMaproom.neighbors.length === 0;

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
  const getNewNeighbours = isCacheExpired(maproom, cacheExpiry) || maproom.neighbors.length < 10;

  if (getNewNeighbours) {
    maproom.neighbors = await findOverworldNeighbours(user, save);

    if (maproom.neighbors.length >= 10)
      maproom.neighborsLastCalculated = currentDate;

    postgres.em.persist(maproom);
    await postgres.em.flush();
  }

  const neighbours = await updateNeighbourData(maproom.neighbors, BaseType.MAIN);

  ctx.status = Status.OK;
  ctx.body = { error: 0, wmbases: [], bases: neighbours };
};

const isCacheExpired = (record: { neighborsLastCalculated?: Date }, cacheExpiry: Date) =>
  !record.neighborsLastCalculated || record.neighborsLastCalculated < cacheExpiry;
