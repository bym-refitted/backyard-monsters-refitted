import { Context, Next } from "koa";
import { getApiVersion } from "../server";
import { Status } from "../enums/StatusCodes";

/**
 * Middleware to enforce API versioning.
 *
 * This middleware checks if the API version provided in the request parameters
 * matches the expected API version on the server. If version management is enabled and the
 * versions do not match, it responds with a 400 Bad Request status.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const apiVersion = async (ctx: Context, next: Next) => {
  const apiVersion = ctx.params.apiVersion;
  const expectedApiVersion = getApiVersion();
  const useVersionManagement = process.env.USE_VERSION_MANAGEMENT === "enabled";

  if (useVersionManagement && apiVersion !== expectedApiVersion) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = {
      error: `Invalid API version. Expected: ${expectedApiVersion}, Recieved: ${apiVersion}`,
    };
    return;
  }

  // If the API version is valid, continue to the next middleware
  await next();
};
