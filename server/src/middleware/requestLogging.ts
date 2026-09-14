import { koaLogger, type KoaLogTapeOptions } from "@logtape/koa";
import type { Context, Next } from "koa";
import { devConfig } from "../config/GameConfig.js";
import { logger } from "../utils/logger.js";

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
    logger.error("MISSING ASSET: {status} {url}", { status: ctx.status, url: ctx.url });
  }
};


/** Options for the LogTape Koa request logger. */
const requestLoggingOptions: KoaLogTapeOptions = {
  category: ["bymr", "http"],
  skip: (ctx) => ctx.url.startsWith("/assets") || ctx.path === "/connection",
  context: { include: ["requestId", "remoteAddr", "userAgent"] },
  format: "structured-common",
};

/**
 * Structured request logging through LogTape.
 *
 * Writes one record per request once the response is sent, using the
 * "structured-common" format: method, url, path, status, responseTime,
 * contentLength and remoteAddr. It omits referrer (always the SWF's URL) and
 * userAgent, which the request context below supplies instead. It logs under
 * ["bymr", "http"] so it inherits the application logger's sinks.
 *
 * It also opens a request-scoped context, so every LogTape record emitted while
 * the request is handled (controllers, ErrorInterceptor) carries the request's
 * requestId, remoteAddr and userAgent. The request ID is read from X-Request-ID
 * when present, generated otherwise, and echoed back in the response header.
 * Relies on contextLocalStorage being configured in utils/logger.ts.
 *
 * Asset requests and the /connection heartbeat (every client, every 30s) are
 * skipped.
 */
export const requestLogging = koaLogger(requestLoggingOptions);
