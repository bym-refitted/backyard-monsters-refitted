import { MapRoomVersion } from "../enums/MapRoom.js";
import { redis } from "../server.js";

const CHANNELS: Record<number, string> = {
  [MapRoomVersion.V1]: "chat:mr1-global",
  [MapRoomVersion.V2]: "chat:mr2-global",
  [MapRoomVersion.V3]: "chat:mr3-global",
};

export const INFERNO_CHAT_CHANNEL = "chat:inferno-global";

export const ALLIANCE_CHANNEL_ALIAS = "alliance";

const ALLIANCE_CHANNEL_PREFIX = "chat:alliance:";

/**
 * What kind of room a channel is, which decides where its messages are stored
 * and which name form they carry.
 *
 * @enum {string}
 */
export enum ChannelType {
  Alliance = "alliance",
  Global = "global",
}

/**
 * Returns the channel key for an alliance's private chat.
 *
 * @param {number} allianceId - The alliance the channel belongs to.
 * @returns {string} The channel key.
 */
export const allianceChannelKey = (allianceId: number) => `${ALLIANCE_CHANNEL_PREFIX}${allianceId}`;

/**
 * Whether a channel key belongs to an alliance rather than a global room.
 *
 * @param {string} channel - The channel key to test.
 * @returns {boolean} True for alliance channels.
 */
export const isAllianceChannel = (channel: string) => channel.startsWith(ALLIANCE_CHANNEL_PREFIX);

/**
 * Reads the alliance id back out of a channel key.
 *
 * @param {string} channel - The channel key to parse.
 * @returns {number | null} The alliance id, or null if this is not an alliance channel.
 */
export const allianceIdFromChannel = (channel: string): number | null => {
  if (!isAllianceChannel(channel)) return null;

  const id = Number(channel.slice(ALLIANCE_CHANNEL_PREFIX.length));

  return Number.isInteger(id) && id > 0 ? id : null;
};

const VALID_CHANNELS = new Set([...Object.values(CHANNELS), INFERNO_CHAT_CHANNEL]);

/**
 * Validates a server-issued global chat channel key echoed back by the client.
 * The server computes the channel during base load and sends it as `chatchannel`.
 * The client echoes it unchanged on join — no parsing or mapping needed here.
 *
 * Alliance channels are not covered here: they are resolved from the joining
 * player's membership instead of being accepted from the client.
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
 * Returns the Redis key holding the set of user IDs a player has ignored.
 *
 * @param {number} userId - The player's user ID.
 * @returns {string} The Redis key for the player's ignore list.
 */
export const chatIgnoreKey = (userId: number) => `chat-ignore:${userId}`;

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
