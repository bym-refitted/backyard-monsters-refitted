import { RateLimit } from "koa2-ratelimit";
import { Env } from "../enums/Env.js";
import { Status } from "../enums/StatusCodes.js";
import type { Context } from "koa";

/**
 * Keys a limiter by account, falling back to IP only for unauthenticated routes.
 *
 * The limiter's prefix is part of the key because koa2-ratelimit keeps every
 * limiter's counters in one shared store and uses a custom keyGenerator's result as
 * the key verbatim; it only adds prefixKey in its default generator. Without the
 * prefix, every limiter keyed by user counts into the same bucket, so browsing the
 * map could rate limit an alliance join request or a username change.
 *
 * @param {string} prefixKey - The limiter's prefixKey, which scopes its counters.
 * @returns {(ctx: Context) => Promise<string>} The key generator for that limiter.
 */
const byUser = (prefixKey: string) => async (ctx: Context) => `${prefixKey}|${ctx.authUser?.userid ?? ctx.ip}`;

/**
 * Rate limit for MR2 getarea - 120 requests per minute per user.
 */
export const getAreaLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 120,
  prefixKey: "getarea",
  keyGenerator: byUser("getarea"),
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
 * Rate limit for client debug logging - 120 requests per minute per IP.
 */
export const debugDataLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 120,
  prefixKey: "debug-data",
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many debug log requests. Please slow down." };
  },
});

/**
 * Rate limit for the MR2 terrain blob - 10 requests per minute per API consumer.
 *
 * Sized so one caller can bootstrap or revalidate every MR2 world inside a
 * single window; 304s pass through the limiter too.
 */
export const terrainLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 10,
  prefixKey: "terrain",
  keyGenerator: async (ctx: Context) => `terrain|${ctx.state.apiConsumer ?? ctx.ip}`,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many terrain requests. Please slow down." };
  },
});

/**
 * Rate limit for the MR2 occupancy snapshot - 10 requests per minute per API consumer.
 *
 * The payload is rebuilt at most once a minute, so anything above that rate is
 * served from cache or answered with a 304.
 */
export const snapshotLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 10,
  prefixKey: "snapshot",
  keyGenerator: async (ctx: Context) => `snapshot|${ctx.state.apiConsumer ?? ctx.ip}`,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many snapshot requests. Please slow down." };
  },
});

/**
 * Rate limit for the MR2 player lookup - 60 requests per minute per API consumer.
 */
export const playersLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 60,
  prefixKey: "players",
  keyGenerator: async (ctx: Context) => `players|${ctx.state.apiConsumer ?? ctx.ip}`,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many player requests. Please slow down." };
  },
});

/**
 * Rate limit for MR3 getcells - 60 requests per minute per user.
 */
export const getCellsLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 60,
  prefixKey: "getcells",
  keyGenerator: byUser("getcells"),
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many cell requests. Please slow down." };
  },
});

/**
 * Rate limit for the alliance browse/search - 30 requests per minute per user.
 */
export const searchAlliancesLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 30,
  prefixKey: "searchalliances",
  keyGenerator: byUser("searchalliances"),
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many alliance searches. Please slow down." };
  },
});

/**
 * Rate limit for a leader inviting players - 20 per minute per user.
 */
export const allianceInviteLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 20,
  prefixKey: "alliance-invite",
  keyGenerator: byUser("alliance-invite"),
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many alliance invites. Please slow down." };
  },
});

/**
 * Rate limit for a player asking to join an alliance - 10 per minute per user.
 */
export const allianceJoinRequestLimiter = RateLimit.middleware({
  interval: { min: 1 },
  max: 10,
  prefixKey: "alliance-join-request",
  keyGenerator: byUser("alliance-join-request"),
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = { error: "Too many join requests. Please slow down." };
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
  keyGenerator: byUser("changeusername"),
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
