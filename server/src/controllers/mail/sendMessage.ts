import { Status } from "../../enums/StatusCodes";
import { saveFailureErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";
import { devConfig } from "../../config/DevSettings";

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
export const sendMessage: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;
    console.log(user);
    const body: any = ctx.request.body;
    console.log(body);
    const isAllowedToSend = devConfig.allowedMessageType[body.type]
    if(!isAllowedToSend) {
      ctx.status = Status.OK;
      ctx.body = { error: 1 };
      return;
    }
    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (err) {
    throw saveFailureErr();
  }
};
