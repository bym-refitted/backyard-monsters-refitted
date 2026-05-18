import { MapRoomVersion } from "../enums/MapRoom.js";
import { redis } from "../server.js";

const CHANNELS: Record<number, string> = {
  [MapRoomVersion.V1]: "chat:mr1-global",
  [MapRoomVersion.V2]: "chat:mr2-global",
  [MapRoomVersion.V3]: "chat:mr3-global",
};

const VALID_CHANNELS = new Set(Object.values(CHANNELS));

/**
 * Validates a server-issued chat channel key echoed back by the client.
 * The server computes the channel during base load and sends it as `chatchannel`.
 * The client echoes it unchanged on join — no parsing or mapping needed here.
 *
 * @param {string} channel - The channel key sent by the client.
 * @returns {string | null} The validated channel key, or null if invalid.
 */
export const validateChannel = (channel: string): string | null => {
  if (!channel) return null;

  return VALID_CHANNELS.has(channel) ? channel : null;
};

/**
 * Returns the Redis key used to store a player's chat authentication token.
 *
 * @param {number} userId - The player's user ID.
 * @returns {string} The Redis key for the player's chat token.
 */
export const chatTokenKey = (userId: number) => `chat-token:${userId}`;

/**
 * Returns the appropriate global chat channel for a player based on their map version.
 *
 * @param {MapRoomVersion} mapversion - The player's current map room version.
 * @returns {string} The chat channel key for the given map version.
 */
export const getChatChannel = (mapversion: MapRoomVersion) => CHANNELS[mapversion];

/**
 * Returns the player's existing chat token from Redis, creating and caching one if absent.
 * Tokens expire after 24 hours.
 *
 * @param {number} userId - The player's user ID.
 * @returns {Promise<string>} The player's chat authentication token.
 */
export const getOrCreateChatToken = async (userId: number): Promise<string> => {
  const existing = await redis.get(chatTokenKey(userId));
  
  if (existing) return existing;

  const token = crypto.randomUUID();
  await redis.setex(chatTokenKey(userId), 86400, token);
  return token;
};
