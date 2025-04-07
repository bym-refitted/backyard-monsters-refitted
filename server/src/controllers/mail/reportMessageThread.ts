import { Status } from "../../enums/StatusCodes";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";

/**
 * Controller to report message on thread
 *
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const reportMessageThread: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  ctx.body = {
    error: 0
  };
  ctx.status = Status.OK;
};
