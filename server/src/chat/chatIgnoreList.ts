import { redis } from "../server.js";
import { chatIgnoreKey } from "./chatChannels.js";
import { send, ServerMessageType } from "./chatProtocol.js";
import { type ChatClient } from "./chatState.js";

/**
 * Sends a client their current ignore list.
 *
 * Display names are left empty: the list is stored as bare user ids and the
 * client already holds names for anyone it has seen speak.
 *
 * @param {ChatClient} client - The client to send the list to.
 */
export const sendIgnoreList = async (client: ChatClient) => {
  const targets = await redis.smembers(chatIgnoreKey(client.userId));

  send(client.ws, {
    type: ServerMessageType.IgnoreList,
    list: targets.map((target) => ({ target, displayname: "" })),
  });
};

/**
 * Adds a user to a client's ignore list, then echoes the updated list back.
 *
 * @param {ChatClient} client - The client doing the ignoring.
 * @param {string} targetId - The user id to ignore.
 */
export const addIgnore = async (client: ChatClient, targetId: string) => {
  await redis.sadd(chatIgnoreKey(client.userId), targetId);
  await sendIgnoreList(client);
};

/**
 * Removes a user from a client's ignore list, then echoes the updated list back.
 *
 * @param {ChatClient} client - The client doing the unignoring.
 * @param {string} targetId - The user id to stop ignoring.
 */
export const removeIgnore = async (client: ChatClient, targetId: string) => {
  await redis.srem(chatIgnoreKey(client.userId), targetId);
  await sendIgnoreList(client);
};
