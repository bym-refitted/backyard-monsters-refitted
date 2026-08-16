import { RateLimit } from "koa2-ratelimit";
import { Env } from "../enums/Env.js";
import { Status } from "../enums/StatusCodes.js";
import type { Context } from "koa";

/**
 * Keys a limit by account, falling back to IP only for unauthenticated routes.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<string>} The rate limit bucket key.
 */
const byUser = async (ctx: Context) => String(ctx.authUser?.userid ?? ctx.ip);

/**
 * Rate limit for MR2 getarea - 120 requests per minute per user.
 */
export const getAreaLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 120,
  prefixKey: "getarea",
  keyGenerator: byUser,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many area requests. Please slow down." };
  },
});

/**
 * Rate limit for the unauthenticated public read routes (worlds, leaderboards).
 * Both are Redis cached, so this bounds cache misses rather than the cached
 * path. Keyed by IP because there is no account to key on.
 */
export const publicReadLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 30,
  prefixKey: "public-read",
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many requests. Please try again shortly." };
  },
});

/**
 * Rate limit for MR3 getcells - 60 requests per minute per user.
 */
export const getCellsLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 60,
  prefixKey: "getcells",
  keyGenerator: byUser,
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
  prefixKey: "register",
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = {
      error:
        "Too many requests where sent from this IP while creating an account. Please try again in 1 hour.",
    };
  },
});

/**
 * Rate limit for username changes - 5 requests per hour per user.
 */
export const changeUsernameLimiter = RateLimit.middleware({
  interval: { min: 60 },
  max: 5,
  prefixKey: "changeusername",
  keyGenerator: byUser,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = {
      error: "Too many username change attempts. Please try again later.",
    };
  },
});

/**
 * Rate limit for login - 30 requests per 5 minutes in prod, 30 per minute in dev.
 */
export const loginLimiter = RateLimit.middleware({
  interval: { min: process.env.ENV === Env.PROD ? 5 : 1 },
  max: 30,
  prefixKey: "login",
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many login attempts. Please try again later." };
  },
});
