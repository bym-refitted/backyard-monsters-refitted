import { Save } from "../models/save.model.js";
import { User } from "../models/user.model.js";
import { postgres, redis } from "../server.js";
import { calculateBaseLevel } from "../services/base/calculateBaseLevel.js";
import { chatTokenKey } from "./chatChannels.js";
import {
  AuthFailReason,
  ClientMessageType,
  ErrorCode,
  send,
  ServerMessageType,
  type ClientMessage,
} from "./chatProtocol.js";
import { leaveAllChannels } from "./chatRooms.js";
import { clients, type ChatClient, type SocketData } from "./chatState.js";

type ServerWebSocket<T> = import("bun").ServerWebSocket<T>;

type AuthMessage = Extract<ClientMessage, { type: ClientMessageType.Auth }>;

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
 * Authenticates a connection and registers it as a {@link ChatClient}.
 *
 * The token is checked against the one issued during base load, then the account
 * is loaded to derive the display name server-side rather than trusting whatever
 * the client claims to be called. A second connection for the same player closes
 * the first, so a player is only ever in one place.
 *
 * @param {ServerWebSocket<SocketData>} ws - The connection authenticating.
 * @param {AuthMessage} message - The client's auth message.
 */
export const authenticate = async (ws: ServerWebSocket<SocketData>, message: AuthMessage) => {
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

  const existing = clients.get(user.userid);

  if (existing) {
    existing.ws.close();
    leaveAllChannels(existing);
  }

  clients.set(user.userid, client);

  send(ws, { type: ServerMessageType.AuthOk, userId: user.userid, displayName });
};
