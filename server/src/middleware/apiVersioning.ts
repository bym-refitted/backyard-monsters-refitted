import type { Context, Next } from "koa";
import { getAndroidVersion, getGameVersion } from "../config/VersionManifestConfig.js";
import { Status } from "../enums/StatusCodes.js";

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
  const apiVersion: string = ctx.params.apiVersion;
  const validVersions = [getGameVersion(), getAndroidVersion()].filter(Boolean) as string[];

  if (validVersions.length > 0 && !validVersions.includes(apiVersion)) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = {
      error: `Invalid API version. Expected one of: ${validVersions.join(", ")}, Received: ${apiVersion}`,
    };
    return;
  }

  await next();
};
