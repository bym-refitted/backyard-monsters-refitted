import type { RedisClient } from "bun";
import { logger } from "./logger.js";

/**
 * Exits the process when a Redis client connects for a second time.
 *
 * @param {RedisClient} client - The Redis client to watch.
 * @param {string} name - Label for the reconnect log line.
 * @param {() => void} [onFirstConnect] - Run once, when the initial connection opens.
 */
export const exitOnRedisReconnect = (client: RedisClient, name: string, onFirstConnect?: () => void) => {
  let hasConnected = false;

  client.onconnect = () => {
    if (hasConnected) {
      logger.fatal(`${name} reconnected, exiting so the process restarts with a fresh connection.`);
      process.exit(1);
    }

    hasConnected = true;
    onFirstConnect?.();
  };
};
