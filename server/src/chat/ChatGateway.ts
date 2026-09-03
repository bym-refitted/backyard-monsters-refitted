import { RedisClient } from "bun";
import { postgres, redis } from "../server.js";
import { User } from "../models/user.model.js";
import { Save } from "../models/save.model.js";
import { logger } from "../utils/logger.js";
import {
  validateChannel,
  chatTokenKey,
  chatIgnoreKey,
  allianceChannelKey,
  ALLIANCE_CHANNEL_ALIAS as ALLIANCE_CHANNEL,
  ChannelType,
} from "./chatChannels.js";
import {
  addAllianceMessage,
  cutAllianceMessages,
  getAllianceMessages,
} from "../services/alliance/allianceMessages.js";
import { pushMessage, getHistory } from "./chatHistory.js";
import { calculateBaseLevel } from "../services/base/calculateBaseLevel.js";
import {
  CHAT_CONTROL_CHANNEL,
  type ChatControlMessage,
} from "./chatControl.js";
import { Filter as BadWords } from "bad-words";
import {
  send,
  ClientMessageType,
  ServerMessageType,
  ErrorCode,
  AuthFailReason,
  type ClientMessage,
  type ServerMessage,
  type HistoryEntry,
} from "./chatProtocol.js";
import { ChatControlType } from "../enums/AllianceMessage.js";

const filter = new BadWords();

export interface SocketData {
  userId: number | null;
  displayName: string;
  lastMsgAt: number;
}

export type ChannelInfo =
  | { type: ChannelType.Alliance; allianceId: number }
  | { type: ChannelType.Global };

interface ResolvedChannel {
  key: string;
  info: ChannelInfo;
}

interface ChatClient {
  ws: ServerWebSocket<SocketData>;
  userId: number;
  displayName: string;
  username: string;
  picSquare: string | null;
  channels: Map<string, ChannelInfo>;
  lastMsgAt: number;
}

type ServerWebSocket<T> = import("bun").ServerWebSocket<T>;

type ChatIdentity = Pick<User, "username" | "pic_square"> & {
  save?: Pick<Save, "points" | "basevalue"> | null;
};

const CHAT_FIELDS = [
  "userid",
  "username",
  "banned",
  "pic_square",
  "save.points",
  "save.basevalue"
] as const;

const RATE_LIMIT_MS = 500;
const MAX_MSG_LEN = 200;

const clients = new Map<number, ChatClient>();
const channelMembers = new Map<string, Set<number>>();

let redisSub: RedisClient;

/**
 * Initialises the dedicated Redis subscriber client used for pub/sub fan-out.
 * Must be called once before any WebSocket connections are accepted.
 */
export const initGateway = () => {
  redisSub = new RedisClient(process.env.REDIS_URL);

  redisSub.onconnect = () => {
    logger.info("Chat Redis subscriber connected");
    redisSub.subscribe(CHAT_CONTROL_CHANNEL, handleControlMessage);
  };

  redisSub.onclose = (err) => logger.error(`Chat Redis subscriber disconnected: ${err.message}`);
  redisSub.connect();
};

/**
 * Handles a control message published by the API process.
 * Membership changes are written there, so this is how the gateway learns that a
 * player it is holding in an alliance channel no longer belongs in it.
 *
 * @param {string} payload - The serialised {@link ChatControlMessage}.
 */
const handleControlMessage = (payload: string) => {
  let message: ChatControlMessage;

  try {
    message = JSON.parse(payload);
  } catch {
    logger.error(`Chat control message was not valid JSON: ${payload}`);
    return;
  }

  if (message.type !== ChatControlType.AllianceEvict) return;

  const client = clients.get(message.userId);

  if (!client) return;

  for (const [channel, info] of [...client.channels]) {
    if (info.type === ChannelType.Alliance) leaveChannel(client, channel);
  }
};

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
const authorizeJoin = async (userid: number, requestedChannel: string): Promise<ResolvedChannel | null> => {
  if (requestedChannel === ALLIANCE_CHANNEL) {
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
const joinChannel = (client: ChatClient, channel: string, channelInfo: ChannelInfo) => {
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
const leaveChannel = (client: ChatClient, channel: string) => {
  if (!client.channels.delete(channel)) return;

  const members = channelMembers.get(channel);  

  if (members) {
    members.delete(client.userId);

    if (members.size === 0) {
      channelMembers.delete(channel);

      redisSub
        .unsubscribe(channel)
        .catch((err) => logger.error(`Chat unsubscribe failed for ${channel}: ${err}`));
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
const leaveAllChannels = (client: ChatClient) => {
  for (const channel of [...client.channels.keys()]) leaveChannel(client, channel);
};

/**
 * Registers the Redis subscription that feeds a channel's local members.
 *
 * @param {string} channel - The channel to subscribe to.
 */
const subscribeToChannel = (channel: string) => {
  redisSub
    .subscribe(channel, (msg) => broadcast(channel, msg))
    .catch((err) => logger.error(`Chat subscribe failed for ${channel}: ${err}`));
};

/**
 * Publishes a raw JSON string to a Redis channel.
 * Fan-out to local WebSocket clients is handled by the fanOut callback on `redisSub`.
 * 
 * @param {string} channel - The Redis channel to publish to.
 * @param {string} payload - The serialised JSON message payload.
 */
const publishToChannel = (channel: string, payload: string) => {
  redis
    .publish(channel, payload)
    .catch((err) => logger.error(`Chat publish error on ${channel}: ${err}`));
};

/**
 * Delivers a raw JSON payload to all locally connected clients in a channel.
 * Called by the `redisSub` subscription callback — handles messages from any process in the cluster.
 * 
 * @param {string} channel - The channel whose members should receive the payload.
 * @param {string} payload - The serialised JSON message payload.
 */
const broadcast = (channel: string, payload: string) => {
  const members = channelMembers.get(channel);
  if (!members) return;

  for (const userId of members) {
    const client = clients.get(userId);
    
    if (!client) continue;

    client.ws.send(payload);
  }
};

/**
 * Returns the entries shown when a channel is joined.
 *
 * @param {string} channel - The channel being joined.
 * @param {ChannelInfo} info - What kind of channel it is.
 * @returns {Promise<HistoryEntry[]>} Entries ordered oldest to newest.
 */
const getChannelHistory = async (channel: string, info: ChannelInfo): Promise<HistoryEntry[]> => {
  if (info.type !== ChannelType.Alliance) return await getHistory(channel);

  const em = postgres.orm.em.fork();
  const messages = await getAllianceMessages(info.allianceId, em);

  return messages.map((message) => ({
    userId: message.userId,
    displayName: message.displayName,
    picSquare: message.picSquare,
    body: message.body,
    ts: message.ts,
  }));
};

/**
 * Called when a new WebSocket connection is opened.
 * Initialises the socket's data to an unauthenticated state.
 * 
 * @param {ServerWebSocket<SocketData>} ws - The newly opened WebSocket connection.
 */
export const handleOpen = (ws: ServerWebSocket<SocketData>) => {
  ws.data = { userId: null, displayName: "", lastMsgAt: 0 };
};

/**
 * The authoritative chat display name for a user.
 *
 * @param {ChatIdentity} user - The authenticated user, with the level fields selected.
 * @returns {string} The display name to broadcast for this user.
 */
const getDisplayName = (user: ChatIdentity): string => {
  const save = user.save;
  const level = save ? calculateBaseLevel(save.points, save.basevalue) : 1;

  return `[${level}] ${user.username}`;
};

/**
 * Parses the incoming JSON, routes to the appropriate handler based on {@link ClientMessageType},
 * and enforces authentication for all message types except `auth`.
 *
 * @param {ServerWebSocket<SocketData>} ws - The WebSocket connection that sent the message.
 * @param {string | Buffer} data - The raw message data received from the client.
 */
const dispatch = async (ws: ServerWebSocket<SocketData>, data: string | Buffer) => {
  let message: ClientMessage;

  try {
    message = JSON.parse(data.toString());
  } catch {
    send(ws, { type: ServerMessageType.Error, code: ErrorCode.InvalidJson });
    return;
  }

  if (message.type === ClientMessageType.Auth) {
    if (ws.data.userId !== null) {
      send(ws, { type: ServerMessageType.Error, code: ErrorCode.AlreadyAuthenticated });
      return;
    }

    const storedToken = await redis.get(chatTokenKey(message.userId));

    if (!storedToken || storedToken !== message.token) {
      send(ws, { type: ServerMessageType.AuthFail, reason: AuthFailReason.InvalidToken });
      ws.close();
      return;
    }

    const em = postgres.orm.em.fork();

    const user = await em.findOne(User, { userid: message.userId }, { fields: CHAT_FIELDS });

    if (!user || user.banned) {
      send(ws, { type: ServerMessageType.AuthFail, reason: AuthFailReason.UserNotFound });
      ws.close();
      return;
    }

    const displayName = getDisplayName(user);

    const client: ChatClient = {
      ws,
      userId: user.userid,
      displayName,
      username: user.username,
      picSquare: user.pic_square ?? null,
      channels: new Map(),
      lastMsgAt: 0,
    };

    ws.data.userId = user.userid;
    ws.data.displayName = displayName;

    // Close any existing connection for this user (reconnect scenario)
    const existing = clients.get(user.userid);
    
    if (existing) {
      existing.ws.close();
      leaveAllChannels(existing);
    }

    clients.set(user.userid, client);

    send(ws, { type: ServerMessageType.AuthOk, userId: user.userid, displayName });
    return;
  }

  // All other messages require authentication
  if (ws.data.userId === null) {
    send(ws, { type: ServerMessageType.Error, code: ErrorCode.NotAuthenticated });
    return;
  }

  const client = clients.get(ws.data.userId);

  if (!client) {
    send(ws, { type: ServerMessageType.Error, code: ErrorCode.NotAuthenticated });
    return;
  }

  switch (message.type) {
    case ClientMessageType.Join: {
      const resolved = await authorizeJoin(client.userId, message.channel);

      if (!resolved) {
        send(ws, { type: ServerMessageType.Error, code: ErrorCode.InvalidChannel });
        return;
      }

      joinChannel(client, resolved.key, resolved.info);

      const history = await getChannelHistory(resolved.key, resolved.info);

      send(ws, { type: ServerMessageType.Joined, channel: resolved.key, history });
      return;
    }

    case ClientMessageType.Leave: {
      leaveChannel(client, message.channel);
      return;
    }


    case ClientMessageType.Say: {
      const now = Date.now();
      const channel = message.channel;
      const info = client.channels.get(channel);

      if (!info) {
        send(ws, { type: ServerMessageType.Error, code: ErrorCode.NotInChannel });
        return;
      }
      
      if (now - client.lastMsgAt < RATE_LIMIT_MS) {
        send(ws, { type: ServerMessageType.Error, code: ErrorCode.RateLimited });
        return;
      }
      
      client.lastMsgAt = now;

      const messageBody = filter.clean(message.message.slice(0, MAX_MSG_LEN).trim());

      if (!messageBody) return;

      const fields = { userId: client.userId, picSquare: client.picSquare, body: messageBody };

      let entry: HistoryEntry;

      if (info.type === ChannelType.Alliance) {
        const record = { allianceId: info.allianceId, userId: client.userId, body: messageBody };
        
        const em = postgres.orm.em.fork();
        const stored = await addAllianceMessage(record, em);

        entry = { ...fields, displayName: client.username, ts: stored.created_at.getTime() };

        await cutAllianceMessages(info.allianceId, em).catch((err) =>
          logger.error(`Trimming alliance ${info.allianceId} messages failed: ${err}`)
        );
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
      return;
    }

    case ClientMessageType.UpdateName:
      return;

    case ClientMessageType.GetIgnore: {
      const ignoreKey = chatIgnoreKey(client.userId);
      const raw = await redis.smembers(ignoreKey);

      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }

    case ClientMessageType.Ignore: {
      const ignoreKey = chatIgnoreKey(client.userId);

      await redis.sadd(ignoreKey, message.targetId);

      const raw = await redis.smembers(ignoreKey);
      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }

    case ClientMessageType.Ping:
      return;

    case ClientMessageType.Unignore: {
      const ignoreKey = chatIgnoreKey(client.userId);

      await redis.srem(ignoreKey, message.targetId);

      const raw = await redis.smembers(ignoreKey);
      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }
  }
};

/**
 * Called when a message is received from a WebSocket client.
 *
 * Bun does not await this handler, so anything that escapes it becomes an unhandled
 * rejection and takes the whole process down with every connection on it. This is the
 * boundary that keeps one player's failed query from disconnecting everyone.
 *
 * @param {ServerWebSocket<SocketData>} ws - The WebSocket connection that sent the message.
 * @param {string | Buffer} data - The raw message data received from the client.
 */
export const handleMessage = async (ws: ServerWebSocket<SocketData>, data: string | Buffer) => {
  try {
    await dispatch(ws, data);
  } catch (err) {
    logger.error(`Chat message handling failed for user ${ws.data.userId}: ${err}`);

    send(ws, { type: ServerMessageType.Error, code: ErrorCode.ServerError });
  }
};

/**
 * Called when a WebSocket connection is closed.
 * Removes the client from their channel and the active clients map.
 * 
 * @param {ServerWebSocket<SocketData>} ws - The WebSocket connection that was closed.
 */
export const handleClose = (ws: ServerWebSocket<SocketData>): void => {
  const userId = ws.data.userId;
  if (userId === null) return;

  const client = clients.get(userId);
  if (!client || client.ws !== ws) return;

  leaveAllChannels(client);
  clients.delete(userId);
};
