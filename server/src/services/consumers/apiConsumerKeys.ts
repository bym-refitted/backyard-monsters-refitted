import { createHash, randomBytes } from "node:crypto";
import type { RedisClient } from "bun";
import type { EntityManager } from "@mikro-orm/postgresql";
import { ApiConsumer } from "../../database/models/apiconsumer.model.js";

export interface GeneratedApiKey {
  key: string;
  keyHash: string;
  keyPrefix: string;
}

export interface CachedApiConsumer {
  id: number;
  name: string;
}

const KEY_PREFIX = "bymr_";

const REVOKED_MARKER = "revoked";

export const CONSUMER_CACHE_TTL = 3600;

/**
 * Redis key for a cached consumer.
 *
 * @param {string} keyHash - The hash of the API key.
 * @returns {string} The cache key.
 */
const consumerCacheKey = (keyHash: string) => `api-consumer:${keyHash}`;

/**
 * Hashes an API key for storage and lookup.
 *
 * @param {string} key - The full API key.
 * @returns {string} The hex-encoded SHA-256 digest.
 */
export const hashApiKey = (key: string) => createHash("sha256").update(key).digest("hex");

/**
 * Generates a new API key.
 *
 * @returns {GeneratedApiKey} The key to hand to the consumer (shown once), its hash
 * to store, and a short prefix to identify it by.
 */
export const generateApiKey = (): GeneratedApiKey => {
  const key = KEY_PREFIX + randomBytes(32).toString("hex");

  return { key, keyHash: hashApiKey(key), keyPrefix: key.slice(0, KEY_PREFIX.length + 8) };
};

/**
 * Finds the active consumer that owns an API key, from Redis when
 * cached and from the database otherwise.
 *
 * Only valid keys are cached, and only if nothing is cached for them yet (NX), so a
 * revoked marker written by consumer:revoke is never overwritten. Random keys from a
 * caller probing the endpoint cannot fill Redis. A database hit refreshes last_used_at,
 * which is therefore accurate to within CONSUMER_CACHE_TTL. Redis errors fall back to
 * the database rather than failing the request.
 *
 * @param {EntityManager} em - The entity manager to query with.
 * @param {RedisClient} redis - The Redis client holding the cache.
 * @param {string} key - The API key sent by the caller.
 * @returns {Promise<CachedApiConsumer | null>} The consumer, or null for an unknown or revoked key.
 */
export const findActiveConsumer = async (em: EntityManager, redis: RedisClient, key: string): Promise<CachedApiConsumer | null> => {
  const keyHash = hashApiKey(key);
  const cacheKey = consumerCacheKey(keyHash);

  const cached = await redis.get(cacheKey).catch(() => null);

  if (cached === REVOKED_MARKER) return null;
  
  if (cached) return JSON.parse(cached);

  const row = await em.findOne(ApiConsumer, { key_hash: keyHash, revoked_at: null }, { fields: ["id", "name"] });

  if (!row) return null;

  const consumer = { id: row.id, name: row.name };

  await Promise.all([
    em.nativeUpdate(ApiConsumer, { id: consumer.id }, { last_used_at: new Date() }),
    redis.set(cacheKey, JSON.stringify(consumer), "EX", String(CONSUMER_CACHE_TTL), "NX").catch(() => null),
  ]);

  return consumer;
};

/**
 * Marks a key as revoked in the cache, so it is rejected on its next request.
 *
 * Overwrites any cached entry rather than deleting it: a lookup that read the key from
 * the database just before the revoke would otherwise be able to cache it again.
 *
 * @param {RedisClient} redis - The Redis client holding the cache.
 * @param {string} keyHash - The hash of the revoked key.
 * @returns {Promise<"OK">} Resolves once the marker is written.
 */
export const markConsumerRevoked = (redis: RedisClient, keyHash: string) =>
  redis.set(consumerCacheKey(keyHash), REVOKED_MARKER, "EX", CONSUMER_CACHE_TTL);
