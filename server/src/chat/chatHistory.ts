import { redis } from "../server.js";
import type { HistoryEntry } from "./chatProtocol.js";

const HISTORY_KEY = (channel: string) => `history:${channel}`;

const MAX_HISTORY = 100;
const HISTORY_TTL_SECONDS = 2592000;

/**
 * Appends a message to a channel's history list, capping it at MAX_HISTORY entries.
 * The TTL is refreshed on every push so the history expires 30 days after the last message.
 *
 * @param {string} channel - The channel key (e.g. `chat:mr1-global`, `chat:mr2-global`, `chat:mr3-global`).
 * @param {HistoryEntry} entry - The message entry to store.
 */
export const pushMessage = async (channel: string, entry: HistoryEntry) => {
  const key = HISTORY_KEY(channel);

  await redis.lpush(key, JSON.stringify(entry));

  await Promise.all([
    redis.ltrim(key, 0, MAX_HISTORY - 1),
    redis.expire(key, HISTORY_TTL_SECONDS),
  ]);
};

/**
 * Returns up to MAX_HISTORY messages for a channel, ordered oldest to newest.
 * @param {string} channel - The channel key to fetch history for.
 *
 * @returns {Promise<HistoryEntry[]>} Ordered array of history entries.
 */
export const getHistory = async (channel: string): Promise<HistoryEntry[]> => {
  const entries = await redis.lrange(HISTORY_KEY(channel), 0, MAX_HISTORY - 1);
  return entries.map((entry) => JSON.parse(entry)).reverse();
};
