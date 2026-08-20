import { Status } from "../../enums/StatusCodes.js";
import { getCachedWorlds } from "../../services/maproom/knownWorlds.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Controller to handle the retrieval of available worlds.
 *
 * The world list is Redis cached and shared with the world id validation used
 * by the leaderboards, so both are served from a single cached read.
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getAvailableWorlds: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { worlds: await getCachedWorlds() };
};
