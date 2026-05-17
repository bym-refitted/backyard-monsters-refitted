import { redis } from "../server.js";
import type { HistoryEntry } from "./chatProtocol.js";

const HISTORY_KEY = (channel: string) => `history:${channel}`;
const MAX_HISTORY = 100;

const HISTORY_TTL_SECONDS = 86400; // 24 hours

export const pushMessage = async (channel: string, entry: HistoryEntry): Promise<void> => {
  const key = HISTORY_KEY(channel);
  await redis.lpush(key, JSON.stringify(entry));
  await Promise.all([
    redis.ltrim(key, 0, MAX_HISTORY - 1),
    redis.expire(key, HISTORY_TTL_SECONDS),
  ]);
};

export const getHistory = async (channel: string): Promise<HistoryEntry[]> => {
  const key = HISTORY_KEY(channel);
  const raw = await redis.lrange(key, 0, MAX_HISTORY - 1);
  // lrange returns newest-first (lpush); reverse so history renders oldest→newest
  return raw
    .map((s) => {
      try { return JSON.parse(s) as HistoryEntry; } catch { return null; }
    })
    .filter((e): e is HistoryEntry => e !== null)
    .reverse();
};
