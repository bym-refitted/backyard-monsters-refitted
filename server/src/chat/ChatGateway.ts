import { RedisClient } from "bun";
import { postgres, redis } from "../server.js";
import { User } from "../models/user.model.js";
import { logger } from "../utils/logger.js";
import { validateChannel, chatTokenKey } from "./chatChannels.js";
import { pushMessage, getHistory } from "./chatHistory.js";
import { Filter as BadWords } from "bad-words";
import {
  send,
  ClientMessageType,
  ServerMessageType,
  ErrorCode,
  AuthFailReason,
  type ClientMessage,
  type ServerMessage,
} from "./chatProtocol.js";

const filter = new BadWords();

export interface SocketData {
  userId: number | null;
  displayName: string;
  channel: string | null;
  lastMsgAt: number;
}

interface ChatClient {
  ws: ServerWebSocket<SocketData>;
  userId: number;
  displayName: string;
  channel: string | null;
  lastMsgAt: number;
}

type ServerWebSocket<T> = import("bun").ServerWebSocket<T>;

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
  redisSub.onconnect = () => logger.info("Chat Redis subscriber connected");
  redisSub.onclose = (err) => logger.error(`Chat Redis subscriber disconnected: ${err.message}`);
  redisSub.connect();
};

/**
 * Subscribes a client to a channel, leaving their previous channel first if needed.
 * Creates the Redis subscription for the channel if this is the first local member.
 * Broadcasts a {@link ServerMessageType.UserEnter} event to the channel on join.
 * 
 * @param {ChatClient} client - The client joining the channel.
 * @param {string} channel - The validated channel key (e.g. `chat:world:{uuid}`).
 */
const joinChannel = (client: ChatClient, channel: string) => {
  if (client.channel === channel) return;

  if (client.channel) leaveChannel(client);

  client.channel = channel;
  client.ws.data.channel = channel;

  if (!channelMembers.has(channel)) {
    channelMembers.set(channel, new Set());
    redisSub.subscribe(channel, (msg: string) => broadcast(channel, msg));
  }

  channelMembers.get(channel)!.add(client.userId);

  const enterMessage: ServerMessage = {
    type: ServerMessageType.UserEnter,
    channel,
    userId: client.userId,
    displayName: client.displayName,
  };

  publishToChannel(channel, JSON.stringify(enterMessage));
};

/**
 * Removes a client from their current channel.
 * Unsubscribes from Redis if no local clients remain in the channel.
 * Broadcasts a {@link ServerMessageType.UserExit} event to the channel on leave.
 * @param {ChatClient} client - The client leaving the channel.
 */
const leaveChannel = (client: ChatClient) => {
  const channel = client.channel;

  if (!channel) return;

  client.channel = null;
  client.ws.data.channel = null;

  const members = channelMembers.get(channel);

  if (members) {
    members.delete(client.userId);
    if (members.size === 0) {
      channelMembers.delete(channel);
      redisSub.unsubscribe(channel);
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
 * Called when a new WebSocket connection is opened.
 * Initialises the socket's data to an unauthenticated state.
 * @param {ServerWebSocket<SocketData>} ws - The newly opened WebSocket connection.
 */
export const handleOpen = (ws: ServerWebSocket<SocketData>) => {
  ws.data = { userId: null, displayName: "", channel: null, lastMsgAt: 0 };
};

/**
 * Called when a message is received from a WebSocket client.
 * Parses the incoming JSON, routes to the appropriate handler based on {@link ClientMessageType},
 * and enforces authentication for all message types except `auth`.
 * 
 * @param {ServerWebSocket<SocketData>} ws - The WebSocket connection that sent the message.
 * @param {string | Buffer} data - The raw message data received from the client.
 */
export const handleMessage = async (ws: ServerWebSocket<SocketData>, data: string | Buffer) => {
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
    const user = await em.findOne(User, { userid: message.userId });

    if (!user || user.banned) {
      send(ws, { type: ServerMessageType.AuthFail, reason: AuthFailReason.UserNotFound });
      ws.close();
      return;
    }

    const displayName = user.username;

    const client: ChatClient = {
      ws,
      userId: user.userid,
      displayName,
      channel: null,
      lastMsgAt: 0,
    };

    ws.data.userId = user.userid;
    ws.data.displayName = displayName;

    // Close any existing connection for this user (reconnect scenario)
    const existing = clients.get(user.userid);
    
    if (existing) {
      existing.ws.close();
      leaveChannel(existing);
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

  const ignoreKey = `chat-ignore:${client.userId}`;

  switch (message.type) {
    case ClientMessageType.Join: {
      const channel = validateChannel(message.channel);

      if (!channel) {
        send(ws, { type: ServerMessageType.Error, code: ErrorCode.InvalidChannel });
        return;
      }

      joinChannel(client, channel);

      const history = await getHistory(channel);
      send(ws, { type: ServerMessageType.Joined, channel, history });
      return;
    }

    case ClientMessageType.Leave: {
      leaveChannel(client);
      return;
    }

    case ClientMessageType.Say: {
      const now = Date.now();

      if (!client.channel) {
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

      const entry = {
        userId: client.userId,
        displayName: client.displayName,
        body: messageBody,
        ts: now,
      };

      await pushMessage(client.channel, entry);

      // Broadcast the new message to the channel via Redis pub/sub
      const broadcast: ServerMessage = { 
        type: ServerMessageType.Message,
        channel: client.channel,
        ...entry
      };
      
      publishToChannel(client.channel, JSON.stringify(broadcast));
      return;
    }

    case ClientMessageType.UpdateName: {
      client.displayName = message.displayName.slice(0, 16);
      ws.data.displayName = client.displayName;
      return;
    }

    case ClientMessageType.GetIgnore: {
      const raw = await redis.smembers(ignoreKey);
      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }

    case ClientMessageType.Ignore: {
      await redis.sadd(ignoreKey, message.targetId);

      const raw = await redis.smembers(ignoreKey);
      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }

    case ClientMessageType.Unignore: {
      await redis.srem(ignoreKey, message.targetId);

      const raw = await redis.smembers(ignoreKey);
      send(ws, { type: ServerMessageType.IgnoreList, list: raw.map((id) => ({ target: id, displayname: "" })) });
      return;
    }
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

  leaveChannel(client);
  clients.delete(userId);
};
