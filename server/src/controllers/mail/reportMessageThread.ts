import { Status } from "../../enums/StatusCodes";
import { debugClientErr } from "../../errors/errors";
import { Thread } from "../../models/thread.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { errorLog, logging } from "../../utils/logger";

const LOG_LEVEL = {
  INFO: "info",
  ERROR: "err",
};
interface DebugData {
  key: string;
  saveid: string;
  value: string;
}

/**
 * Controller to report message on thread
 *
 * This controller report
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
