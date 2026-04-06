import { RateLimit } from "koa2-ratelimit";
import { Env } from "../enums/Env.js";
import { Status } from "../enums/StatusCodes.js";
import type { Context } from "koa";

/**
 * Rate limit for MR3 getcells - 60 requests per minute per user.
 */
export const getCellsLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 60,
  prefixKey: "getcells",
  keyGenerator: async (ctx: Context) => ctx.authUser?.userid ?? ctx.ip,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many cell requests. Please slow down." };
  },
});

/**
 * Rate limit for user registration - 3 requests per hour in prod, per minute in dev.
 */
export const registerLimiter = RateLimit.middleware({
  interval: { min: process.env.ENV === Env.PROD ? 60 : 1 },
  max: 3,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = {
      error:
        "Too many requests where sent from this IP while creating an account. Please try again in 1 hour.",
    };
  },
});
