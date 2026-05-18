export enum ClientMessageType {
  Auth = "auth",
  Join = "join",
  Say = "say",
  Leave = "leave",
  GetIgnore = "getignore",
  Ignore = "ignore",
  Unignore = "unignore",
  UpdateName = "updatename",
}

export enum ServerMessageType {
  AuthOk = "auth_ok",
  AuthFail = "auth_fail",
  Joined = "joined",
  Message = "message",
  UserEnter = "user_enter",
  UserExit = "user_exit",
  IgnoreList = "ignore_list",
  Error = "error",
}

export enum ErrorCode {
  InvalidJson = "invalid_json",
  AlreadyAuthenticated = "already_authenticated",
  RateLimited = "rate_limited",
  NotAuthenticated = "not_authenticated",
  InvalidChannel = "invalid_channel",
  NotInChannel = "not_in_channel",
}

export enum AuthFailReason {
  InvalidToken = "invalid_token",
  UserNotFound = "user_not_found",
}

export interface HistoryEntry {
  userId: number;
  displayName: string;
  body: string;
  ts: number;
}

export interface IgnoreEntry {
  target: string;
  displayname: string;
}

export type ClientMessage =
  | { type: ClientMessageType.Auth; userId: number; token: string }
  | { type: ClientMessageType.Join; channel: string }
  | { type: ClientMessageType.Say; channel: string; message: string }
  | { type: ClientMessageType.Leave; channel: string }
  | { type: ClientMessageType.GetIgnore }
  | { type: ClientMessageType.Ignore; targetId: string }
  | { type: ClientMessageType.Unignore; targetId: string }
  | { type: ClientMessageType.UpdateName; displayName: string };

export type ServerMessage =
  | { type: ServerMessageType.AuthOk; userId: number; displayName: string }
  | { type: ServerMessageType.AuthFail; reason: AuthFailReason }
  | { type: ServerMessageType.Joined; channel: string; history: HistoryEntry[] }
  | { type: ServerMessageType.Message; channel: string; userId: number; displayName: string; body: string; ts: number }
  | { type: ServerMessageType.UserEnter; channel: string; userId: number; displayName: string }
  | { type: ServerMessageType.UserExit; channel: string; userId: number }
  | { type: ServerMessageType.IgnoreList; list: IgnoreEntry[] }
  | { type: ServerMessageType.Error; code: ErrorCode };

interface Sender { send(data: string): void; }

/**
 * Serialises a {@link ServerMessage} to JSON and sends it over the WebSocket.
 * @param {Sender} ws - The WebSocket connection to send the message on.
 * @param {ServerMessage} msg - The typed server message to send.
 */
export const send = (ws: Sender, msg: ServerMessage): void => ws.send(JSON.stringify(msg));
