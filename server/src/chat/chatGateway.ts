import { ChatControlType } from "../enums/AllianceMessage.js";
import { logger } from "../utils/logger.js";
import { ChannelType } from "./chatChannels.js";
import { type ChatControlMessage } from "./chatControl.js";
import {
  ClientMessageType,
  ErrorCode,
  send,
  ServerMessageType,
  type ClientMessage,
} from "./chatProtocol.js";
import { authenticate } from "./chatIdentity.js";
import { addIgnore, removeIgnore, sendIgnoreList } from "./chatIgnoreList.js";
import {
  authorizeJoin,
  getChannelHistory,
  joinChannel,
  leaveAllChannels,
  leaveChannel,
  postMessage,
} from "./chatRooms.js";
import { clients, type SocketData } from "./chatState.js";
import { initTransport, subscribeControl } from "./chatTransport.js";

type ServerWebSocket<T> = import("bun").ServerWebSocket<T>;

/**
 * Brings the gateway up: opens the Redis subscriber and, once it connects,
 * subscribes to the control channel. Must be called once before any WebSocket
 * connections are accepted.
 */
export const initGateway = () => initTransport(() => subscribeControl(handleControlMessage));

/**
 * Handles a control message published by the API side.
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
 * Called when a new WebSocket connection is opened.
 * Initialises the socket's data to an unauthenticated state.
 *
 * @param {ServerWebSocket<SocketData>} ws - The newly opened WebSocket connection.
 */
export const handleOpen = (ws: ServerWebSocket<SocketData>) => {
  ws.data = { userId: null, displayName: "", lastMsgAt: 0 };
};

/**
 * Parses the incoming JSON, routes to the appropriate handler based on
 * {@link ClientMessageType}, and enforces authentication for all message types
 * except `auth`.
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
    await authenticate(ws, message);
    return;
  }

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

    case ClientMessageType.Leave:
      leaveChannel(client, message.channel);
      return;

    case ClientMessageType.Say:
      await postMessage(client, message.channel, message.message);
      return;

    case ClientMessageType.GetIgnore:
      await sendIgnoreList(client);
      return;

    case ClientMessageType.Ignore:
      await addIgnore(client, message.targetId);
      return;

    case ClientMessageType.Unignore:
      await removeIgnore(client, message.targetId);
      return;

    case ClientMessageType.UpdateName:
    case ClientMessageType.Ping:
      return;
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
 * Removes the client from every channel and from the active clients map.
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
