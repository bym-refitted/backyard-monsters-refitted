import type { Next } from "koa";
import type { RouterContext } from "@koa/router";
import { isAcceptedVersion } from "../config/VersionManifestConfig.js";
import { versionMismatchErr } from "../errors/errors.js";

/**
 * Middleware to enforce API versioning.
 *
 * This middleware checks if the API version provided in the request parameters
 * matches the expected API version on the server. If version management is enabled and the
 * versions do not match, it throws versionMismatchErr (400, code GAME_OUTDATED).
 *
 * @param {RouterContext} ctx - The Koa context object, with the route's params.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const apiVersion = async (ctx: RouterContext, next: Next) => {
  const { apiVersion } = ctx.params;
  const acceptedVersion = isAcceptedVersion(apiVersion);

  if (!acceptedVersion) throw versionMismatchErr(apiVersion);

  await next();
};
