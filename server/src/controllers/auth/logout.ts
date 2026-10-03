import { Status } from "../../enums/StatusCodes.js";
import { redis } from "../../server.js";
import { sessionTokenKey } from "../../middleware/auth.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Ends the caller's session on the server.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const logout: KoaController = async (ctx) => {
  await redis.del(sessionTokenKey(ctx.sessionType, ctx.authUser.email));

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
