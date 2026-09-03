import { ChatControlType } from "../enums/AllianceMessage.js";
import { redis } from "../server.js";
import { logger } from "../utils/logger.js";

export const CHAT_CONTROL_CHANNEL = "chat:control";

export type ChatControlMessage = {
  type: ChatControlType.AllianceEvict;
  userId: number;
};

/**
 * Forces a player out of their alliance chat channel.
 *
 * Membership is written by the API process while the channel roster lives in the
 * chat process, so a player kicked or removed mid-session would otherwise keep
 * reading their old alliance's messages until they happened to disconnect.
 *
 * @param {number} userId - The player to evict.
 */
export const disconnectAllianceChat = async (userId: number) => {
  const message: ChatControlMessage = { type: ChatControlType.AllianceEvict, userId };

  await redis
    .publish(CHAT_CONTROL_CHANNEL, JSON.stringify(message))
    .catch((err) => logger.error(`Chat control publish failed for user ${userId}: ${err}`));
};
