import type { Context, Next } from "koa";
import { postgres, redis } from "../server.js";
import { Env } from "../enums/Env.js";
import { Status } from "../enums/StatusCodes.js";
import { findActiveConsumer } from "../services/consumers/apiConsumerKeys.js";

/**
 * Restricts a route to registered API consumers.
 *
 * Expects an active key from bym.api_consumer in the X-API-Key header. Validated
 * keys are cached in Redis, and revoking a key clears its entry, so repeat requests
 * skip the database without delaying revocation. Keys are issued, listed and
 * revoked with `bun run consumer:create|list|revoke`. On success the consumer's
 * name is recorded on ctx.state.apiConsumer for rate limiting.
 *
 * Responds with a plain 401 rather than throwing a ClientSafeError, because
 * ErrorInterceptor rewrites those to a 200 for the Flash client, which would
 * mislead a non-Flash caller.
 *
 * Skipped when ENV=local so the bulk endpoints can be exercised without a key.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} A promise that resolves when the middleware is complete.
 */
export const verifyApiConsumer = async (ctx: Context, next: Next) => {
  if (process.env.ENV === Env.LOCAL) return next();

  const key = ctx.get("x-api-key");
  
  const consumer = key ? await findActiveConsumer(postgres.em, redis, key) : null;

  if (!consumer) {
    ctx.status = Status.UNAUTHORIZED;
    ctx.body = { error: "Missing or invalid API key" };
    return;
  }

  ctx.state.apiConsumer = consumer.name;

  await next();
};
