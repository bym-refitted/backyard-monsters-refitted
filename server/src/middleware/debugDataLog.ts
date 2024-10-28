import { Context, Next } from "koa";
import { errorLog, logging } from "../utils/logger";
import { Env } from "../enums/Env";

/**
 * Middleware to log request body data for debugging purposes.
 *
 * This middleware logs the request body data to the console. If the environment
 * is set to local and the `chalk` library is available, it uses `chalk` to
 * highlight the log message. If `chalk` is not available, it logs the message
 * in a normal format.
 *
 * @param {string} [logMessage="Request body"] - The message to log before the request body.
 * @returns {Function} Koa middleware function.
 */
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
