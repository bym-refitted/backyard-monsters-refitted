import { Status } from "../../enums/StatusCodes";
import { debugClientErr } from "../../errors/errors";
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
      errorLog(
        `ERROR logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    } else {
      logging(
        `INFO logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    }

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (err) {
    throw debugClientErr();
  }
};
