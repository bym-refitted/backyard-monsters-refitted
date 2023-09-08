import Router from "@koa/router";
import { logging } from "../utils/logger.js";
import { randomUUID } from "crypto";
import { Context, Next } from "koa";

interface LogProps {
  logMessage: string;
  debugVars: Object;
}

const router = new Router();

// Logging routes
router.post(
  "/api/player/recorddebugdata",
  async (ctx: Context) => {
    logging(`=========== NEW RUN ${randomUUID()} ===========`);
    const requestLog = ctx.request.body as { message: string };

    JSON.parse(requestLog.message).forEach((element: LogProps) => {
      logging(`${element.logMessage}`, element.debugVars);
    });
  }
);

export default router;
