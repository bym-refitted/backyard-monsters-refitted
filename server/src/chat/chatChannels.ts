import { redis } from "../server.js";

const MR1_CHANNEL = "chat:mr1-global";

/**
 * Validates a server-issued chat channel key echoed back by the client.
 * The server computes the channel during base load and sends it as `chatchannel`.
 * The client echoes it unchanged on join — no parsing or mapping needed here.
 *
 * Valid forms:
 *   "chat:world:{uuid}" - MR2/MR3 player; worldid issued by the server in the base load response
 *   "chat:mr1-global" - MR1 player or player without a world
 */
export const validateChannel = (raw: string): string | null => {
  if (!raw) return null;
  if (raw.startsWith("chat:world:") || raw === MR1_CHANNEL) return raw;

  return null;
};

export const chatTokenKey = (userId: number) => `chat-token:${userId}`;

/**
 * Returns the appropriate chat channel for a player.
 * MR2/MR3 players (with a worldid) join their world channel; MR1 players all share one global channel.
 */
export const getChatChannel = (worldid: string | null | undefined): string =>
  worldid ? `chat:world:${worldid}` : MR1_CHANNEL;

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
