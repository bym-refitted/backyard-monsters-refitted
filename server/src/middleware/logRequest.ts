import type { Context, Next } from "koa";
import { inspect } from "util";
import { Env } from "../enums/Env.js";

/**
 * Middleware to log request data for debugging purposes.
 *
 * This middleware logs request information to the console in local environments
 * with formatted output for better readability.
 *
 * @param {string} [logMessage=""] - Optional label for the log entry.
 * @returns {Function} Koa middleware function.
 */
export const logRequest = (logMessage: string = "") =>
  async (ctx: Context, next: Next) => {
    if (process.env.ENV === Env.LOCAL) {
      console.log("=".repeat(70));
      console.log(`📦 ${ctx.method} ${ctx.path}${logMessage ? ` | ${logMessage}` : ""}`);

      if (ctx.request.body && Object.keys(ctx.request.body).length > 0) {
        console.log();
        console.log(inspect(ctx.request.body, { colors: true, depth: 5, compact: false }));
      }

      console.log("=".repeat(70) + "\n");
    }
    await next();
  };
