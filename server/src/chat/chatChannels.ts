import { redis } from "../server.js";

/**
 * Validates a server-issued chat channel key echoed back by the client.
 * The server computes the channel during base load and sends it as `chatchannel`.
 * The client echoes it unchanged on join — no parsing or mapping needed here.
 *
 * Valid forms:
 *   "chat:world:{uuid}"   — MR2/MR3 player; worldid issued by the server in the base load response
 *   "chat:sector:{n}"     — MR1 player or player without a world
 */
export const validateChannel = (raw: string): string | null => {
  if (!raw) return null;
  if (raw.startsWith("chat:world:") || raw.startsWith("chat:sector:")) return raw;

  return null;
};

export const chatTokenKey = (userId: number) => `chat-token:${userId}`;

/**
 * Returns the appropriate chat channel for a player.
 * MR2/MR3 players (with a worldid) join their world channel; MR1 players are bucketed into one of 50 sector channels.
 */
export const getChatChannel = (worldid: string | null | undefined, userId: number): string =>
  worldid ? `chat:world:${worldid}` : `chat:sector:${userId % 50}`;

/**
 * Returns the player's existing chat token from Redis, creating and caching one if absent.
 * Tokens expire after 24 hours.
 */
export const getOrCreateChatToken = async (userId: number): Promise<string> => {
  const existing = await redis.get(chatTokenKey(userId));
  if (existing) return existing;

  const token = crypto.randomUUID();
  await redis.setex(chatTokenKey(userId), 86400, token);
  return token;
};
