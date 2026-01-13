import { Status } from "../../enums/StatusCodes.js";
import { debugClientErr } from "../../errors/errors.js";
import { KoaController } from "../../utils/KoaController.js";
import { logger } from "../../utils/logger.js";

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
 * Controller to record debug data.
 *
 * This controller logs debug information sent from the client. It logs either an
 * error or info message depending on the key provided by the client. 
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const recordDebugData: KoaController = async (ctx) => {
  try {
    const body = ctx.request.body as DebugData;

    if (!body.key || !body.saveid || !body.value) throw debugClientErr();

    if (body.key === LOG_LEVEL.ERROR) {
      logger.error(
        `ERROR logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    } else {
      logger.info(
        `INFO logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    }

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (err) {
    throw debugClientErr();
  }
};
