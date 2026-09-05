import { Filter as BadWords } from "bad-words";

import { User } from "../models/user.model.js";
import { postgres } from "../server.js";
import {
  addAllianceMessage,
  getAllianceMessages,
} from "../services/alliance/allianceMessages.js";
import { AllianceMessageType } from "../enums/Alliance.js";
import {
  allianceChannelKey,
  validateChannel,
} from "./chatChannels.js";
import { getHistory, pushMessage } from "./chatHistory.js";
import {
  ErrorCode,
  send,
  ServerMessageType,
  type HistoryEntry,
  type ServerMessage,
} from "./chatProtocol.js";
import { channelMembers, type ChannelInfo, type ChatClient } from "./chatState.js";
import {
  publishToChannel,
  subscribeToChannel,
  unsubscribeFromChannel,
} from "./chatTransport.js";
import { ALLIANCE_CHANNEL_ALIAS } from "../config/ChatConfig.js";
import { ChannelType } from "../enums/Chat.js";

interface ResolvedChannel {
  key: string;
  info: ChannelInfo;
}

const filter = new BadWords();

const RATE_LIMIT_MS = 500;
const MAX_MSG_LEN = 200;

/**
 * Resolves the channel a client is asking to join into a real channel key.
 *
 * Global rooms are validated against the fixed set the server issues at base load.
 * Alliance chat is different: the client sends only the ALLIANCE_CHANNEL_ALIAS
 * and the key is derived from the player's own membership, so no client can name
 * another alliance's channel regardless of what it sends.
 *
 * @param {number} userid - The player requesting the join.
 * @param {string} requestedChannel - The channel name as sent by the client.
 * @returns {Promise<ResolvedChannel | null>} The channel key and its kind, or null if not permitted.
 */
export const authorizeJoin = async (userid: number, requestedChannel: string): Promise<ResolvedChannel | null> => {
  if (requestedChannel === ALLIANCE_CHANNEL_ALIAS) {
    const em = postgres.orm.em.fork();
    const user = await em.findOne(User, { userid }, { fields: ["alliance_id"] });

    if (!user) return null;

    if (!user.alliance_id) return null;

    const key = allianceChannelKey(user.alliance_id);

    return { key, info: { type: ChannelType.Alliance, allianceId: user.alliance_id } };
  }

  const key = validateChannel(requestedChannel);

  if (!key) return null;

  return { key, info: { type: ChannelType.Global } };
};

/**
 * Subscribes a client to a channel, in addition to any they are already in.
 * Creates the Redis subscription for the channel if this is the first local member.
 * Broadcasts a {@link ServerMessageType.UserEnter} event to the channel on join.
 *
 * @param {ChatClient} client - The client joining the channel.
 * @param {string} channel - The resolved channel key (e.g. `chat:alliance:{id}`).
 * @param {ChannelInfo} channelInfo - What kind of channel it is, from {@link authorizeJoin}.
 */
export const joinChannel = (client: ChatClient, channel: string, channelInfo: ChannelInfo) => {
  if (client.channels.has(channel)) return;

  client.channels.set(channel, channelInfo);

  let members = channelMembers.get(channel);

  if (!members) {
    members = new Set();
    channelMembers.set(channel, members);
    subscribeToChannel(channel);
  }

  members.add(client.userId);

  const enterMessage: ServerMessage = {
    type: ServerMessageType.UserEnter,
    channel,
    userId: client.userId,
    displayName: client.displayName,
  };

  publishToChannel(channel, JSON.stringify(enterMessage));
};

/**
 * Removes a client from one of the channels they are in.
 * Unsubscribes from Redis if no local clients remain in the channel.
 * Broadcasts a {@link ServerMessageType.UserExit} event to the channel on leave.
 *
 * @param {ChatClient} client - The client leaving.
 * @param {string} channel - The channel being left.
 */
export const leaveChannel = (client: ChatClient, channel: string) => {
  if (!client.channels.delete(channel)) return;

  const members = channelMembers.get(channel);

  if (members) {
    members.delete(client.userId);

    if (members.size === 0) {
      channelMembers.delete(channel);
      unsubscribeFromChannel(channel);
    }
  }

  const exitMessage: ServerMessage = {
    type: ServerMessageType.UserExit,
    channel,
    userId: client.userId,
  };

  publishToChannel(channel, JSON.stringify(exitMessage));
};

/**
 * Removes a client from every channel they are in, used when the connection ends.
 *
 * @param {ChatClient} client - The client being disconnected.
 */
export const leaveAllChannels = (client: ChatClient) => {
  for (const channel of [...client.channels.keys()]) leaveChannel(client, channel);
};

/**
 * Returns the entries shown when a channel is joined.
 *
 * @param {string} channel - The channel being joined.
 * @param {ChannelInfo} info - What kind of channel it is.
 * @returns {Promise<HistoryEntry[]>} Entries ordered oldest to newest.
 */
export const getChannelHistory = async (channel: string, info: ChannelInfo): Promise<HistoryEntry[]> => {
  if (info.type !== ChannelType.Alliance) return await getHistory(channel);

  const em = postgres.orm.em.fork();
  return await getAllianceMessages(info.allianceId, em);
};

/**
 * Accepts a chat line from a client and broadcasts it to the channel.
 *
 * Where the line is stored depends on the room: alliance chat is durable in
 * Postgres and trimmed to a sliding window, while global rooms keep a capped
 * Redis list. Either way the client is told nothing about which happened.
 *
 * @param {ChatClient} client - The client sending the message.
 * @param {string} channel - The channel to post into.
 * @param {string} body - The raw message text as sent by the client.
 */
export const postMessage = async (client: ChatClient, channel: string, body: string) => {
  const info = client.channels.get(channel);

  if (!info) {
    send(client.ws, { type: ServerMessageType.Error, code: ErrorCode.NotInChannel });
    return;
  }

  const now = Date.now();

  if (now - client.lastMsgAt < RATE_LIMIT_MS) {
    send(client.ws, { type: ServerMessageType.Error, code: ErrorCode.RateLimited });
    return;
  }

  client.lastMsgAt = now;

  const messageBody = filter.clean(body.slice(0, MAX_MSG_LEN).trim());

  if (!messageBody) return;

  const fields = {
    userId: client.userId,
    picSquare: client.picSquare,
    allianceImage: null,
    body: messageBody,
    messageType: AllianceMessageType.MESSAGE,
  };

  let entry: HistoryEntry;

  if (info.type === ChannelType.Alliance) {
    const record = { allianceId: info.allianceId, userId: client.userId, body: messageBody };

    const em = postgres.orm.em.fork();
    const stored = await addAllianceMessage(record, em);

    entry = { ...fields, displayName: client.username, ts: stored.created_at.getTime() };
  } else {
    entry = { ...fields, displayName: client.displayName, ts: now };

    await pushMessage(channel, entry);
  }

  const outgoing: ServerMessage = {
    type: ServerMessageType.Message,
    channel,
    ...entry,
    userId: client.userId,
  };

  publishToChannel(channel, JSON.stringify(outgoing));
};
