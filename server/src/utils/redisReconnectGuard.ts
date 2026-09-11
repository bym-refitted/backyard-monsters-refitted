import type { RedisClient } from "bun";
import { logger } from "./logger.js";

/**
 * Exits the process when a Redis client connects for a second time.
 *
 * After an automatic reconnect, Bun's RedisClient can hand replies to the wrong
 * commands (oven-sh/bun#27861), so every login token lookup fails until the process
 * restarts. Exiting lets the supervisor (PM2 or Docker) start a fresh process with a
 * clean connection. `onclose` is not used because it does not fire in production.
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
