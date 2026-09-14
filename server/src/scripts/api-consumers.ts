import mikroOrmConfig from "../mikro-orm.config.js";

import { RedisClient } from "bun";
import { MikroORM } from "@mikro-orm/core";
import { dispose } from "@logtape/logtape";
import { ApiConsumer } from "../database/models/apiconsumer.model.js";
import {
  CONSUMER_CACHE_TTL,
  generateApiKey,
  markConsumerRevoked,
} from "../services/consumers/apiConsumerKeys.js";
import { logger } from "../utils/logger.js";

enum ConsumerCommand {
  CREATE = "create",
  LIST = "list",
  REVOKE = "revoke",
}

/**
 * Manages the API keys issued to external apps (bym.api_consumer).
 *
 * Run from the server directory:
 *   bun run consumer:create <name>   Issues a new key and prints it once. Only its hash is stored.
 *   bun run consumer:list            Lists every key with its prefix, last use and status.
 *   bun run consumer:revoke <id>     Revokes a key and marks it revoked in the server's Redis cache,
 *                                    so it stops working on the consumer's next request.
 *
 * To rotate a consumer's key, create a second key under the same name, hand it over,
 * then revoke the old one once they have switched.
 */

const keyLogger = logger.getChild("keys");

/**
 * Issues a key for a consumer and prints it.
 *
 * @param {MikroORM} orm - The initialised ORM.
 * @param {string | undefined} name - The consumer's name, e.g. "maproom2".
 * @returns {Promise<void>}
 */
const createKey = async (orm: MikroORM, name: string | undefined) => {
  const nameTrimmed = name?.trim();

  if (!nameTrimmed) throw new Error("A consumer name is required. Check usage.");

  const { key, keyHash, keyPrefix } = generateApiKey();
  const em = orm.em.fork();

  const consumer = em.create(ApiConsumer, { name: nameTrimmed, key_prefix: keyPrefix, key_hash: keyHash });
  await em.flush();

  keyLogger.info("Created key #{id} for {name} | Prefix: {prefix}", {
    event: "api_key.created",
    id: consumer.id,
    name: consumer.name,
    prefix: keyPrefix,
  });

  console.log(`\n  ${key}\n\nCopy it now, it cannot be shown again. The consumer sends it as the X-API-Key header.\n`);
};

/**
 * Logs every key, active and revoked, one line per key.
 *
 * @param {MikroORM} orm - The initialised ORM.
 * @returns {Promise<void>}
 */
const listKeys = async (orm: MikroORM) => {
  const keys = await orm.em.fork().find(ApiConsumer, {}, { orderBy: { id: "asc" } });

  if (keys.length === 0) {
    keyLogger.info("No keys issued");
    return;
  }

  for (const key of keys) {
    keyLogger.info("#{id} {name} | Prefix: {prefix} | Status: {status} | Last used: {lastUsed}", {
      id: key.id,
      name: key.name,
      prefix: key.key_prefix,
      status: key.revoked_at ? `revoked ${key.revoked_at.toISOString()}` : "active",
      lastUsed: key.last_used_at?.toISOString() ?? "never",
      created: key.created_at.toISOString(),
    });
  }
};

/**
 * Revokes an active key in the database and marks it revoked in the Redis cache.
 *
 * @param {MikroORM} orm - The initialised ORM.
 * @param {string | undefined} keyIdInput - The key's id as typed on the command line, as shown by consumer:list.
 * @returns {Promise<void>}
 */
const revokeKey = async (orm: MikroORM, keyIdInput: string | undefined) => {
  const id = Number(keyIdInput);
  const isValidId = Number.isInteger(id) && id > 0;

  if (!isValidId) throw new Error("A key id is required. Check usage.");

  const em = orm.em.fork();
  const revoked = await em.nativeUpdate(ApiConsumer, { id, revoked_at: null }, { revoked_at: new Date() });

  if (revoked === 0) {
    keyLogger.info("No active key #{id} | Check consumer:list", { id });
    return;
  }

  const key = await em.findOneOrFail(ApiConsumer, { id });

  const logProperties = {
    event: "api_key.revoked",
    id,
    name: key.name,
    prefix: key.key_prefix,
  };

  keyLogger.info("Revoked key #{id} for {name} | Prefix: {prefix}", logProperties);

  const redis = new RedisClient(process.env.REDIS_URL);

  try {
    await redis.connect();
    await markConsumerRevoked(redis, key.key_hash);
  } catch (error) {
    const logProperties = {
      event: "api_key.cache_revoke_failed",
      id,
      ttlMinutes: CONSUMER_CACHE_TTL / 60,
      error,
    };

    keyLogger.error("Could not mark key #{id} revoked in Redis cache | Valid for up to {ttlMinutes} min", logProperties);
    process.exitCode = 1;
  } finally {
    redis.close();
  }
};

(async () => {
  const [command, arg] = process.argv.slice(2);

  try {
    const orm = await MikroORM.init(mikroOrmConfig);

    try {
      switch (command) {
        case ConsumerCommand.CREATE:
          await createKey(orm, arg);
          break;

        case ConsumerCommand.LIST:
          await listKeys(orm);
          break;

        case ConsumerCommand.REVOKE:
          await revokeKey(orm, arg);
          break;

        default:
          throw new Error("Check usage.");
      }
    } finally {
      await orm.close();
    }
  } catch (error) {
    const logProperties = {
      event: "api_key.command_failed",
      command,
      message: (error as Error).message,
      error,
    };
    
    keyLogger.error("{command} failed | {message}", logProperties);
    process.exitCode = 1;
  }

  await dispose();
  process.exit();
})();
