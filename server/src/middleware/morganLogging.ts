import { devConfig } from "../config/DevSettings.js";
import { logger } from "../utils/logger.js";
import morgan from "koa-morgan";
import { Context, Next } from "koa";

/**
 * Middleware to log missing assets.
 * 
 * This middleware checks if the requested URL is an asset and if the response
 * status is 404 (Not Found). If so, it logs the missing asset to the console.
 * 
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const logMissingAssets = async (ctx: Context, next: Next) => {
  await next();

  const assetURI = ctx.url.startsWith("/assets");

  if (assetURI && ctx.status === 404 && devConfig.logMissingAssets) {
    logger.error(`${`Missing Asset:`.toUpperCase()} ${ctx.status} ${ctx.url}`);
  }
};

const logFormat = "Server: :method :status :url";

/**
 * Morgan logging middleware.
 * 
 * This middleware uses Morgan to log HTTP requests. It skips logging for URLs
 * that start with "/assets".
 * 
 * @type {Function}
 */
export const morganLogging = morgan(logFormat, {
  skip: (ctx) => ctx.url.startsWith("/assets"),
});
