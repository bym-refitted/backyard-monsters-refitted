import { Context, Next } from "koa";
import { Status } from "../enums/StatusCodes";

/**
 * Middleware to set CORS headers and apply cache control.
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @param {Next} next - The next middleware function in the stack.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const corsCacheControl = async (ctx: Context, next: Next) => {
  // Allow all origins
  ctx.set("Access-Control-Allow-Origin", "*");
  ctx.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  ctx.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Apply no-cache headers to all routes except static files.
  // This is to prevent caching of API responses on the client.
  // Client needs fresh data on every request otherwise unexpected behavior can occur.
  if (!ctx.path.startsWith("/public")) {
    ctx.set("Cache-Control", "no-cache, no-store, must-revalidate");
    ctx.set("Pragma", "no-cache");
    ctx.set("Expires", "0");
  }

  // Handle preflight requests
  if (ctx.method === "OPTIONS") {
    ctx.status = Status.NO_CONTENT;
    return;
  }

  await next();
};
