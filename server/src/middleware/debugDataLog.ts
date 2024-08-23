import { Context, Next } from "koa";
import { errorLog, logging } from "../utils/logger";
import { Env } from "../enums/Env";

export const debugDataLog =
  (logMessage: string = "Request body") =>
  async (ctx: Context, next: Next) => {
    let chalk: any;

    try {
      chalk = await import("chalk");
    } catch (error) {
      errorLog("Failed to import chalk: ", error);
    }

    if (chalk) {
      const highlight = chalk.default.yellow.bold;

      if (process.env.ENV === Env.LOCAL) {
        logging(
          `${highlight(`${logMessage.toUpperCase()}:`)} ${JSON.stringify(
            ctx.request.body
          )}`
        );
      }
    } else {
      if (process.env.ENV === Env.LOCAL) {
        // If chalk import fails, continue with normal log format
        logging(
          `${logMessage.toUpperCase()}: ${JSON.stringify(ctx.request.body)}`
        );
      }
    }
    await next();
  };
