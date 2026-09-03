import type { ChannelType } from "./chatChannels.js";

type ServerWebSocket<T> = import("bun").ServerWebSocket<T>;

/**
 * What Bun stores on the socket itself, which is only enough to find the
 * client's ChatClient and to answer before authentication completes.
 */
export interface SocketData {
  userId: number | null;
  displayName: string;
  lastMsgAt: number;
}

/**
 * What kind of room a channel is, carried alongside the key so nothing has to
 * parse an alliance id back out of the channel string.
 */
export type ChannelInfo =
  | { type: ChannelType.Alliance; allianceId: number }
  | { type: ChannelType.Global };

/** An authenticated connection and every channel it currently holds. */
export interface ChatClient {
  ws: ServerWebSocket<SocketData>;
  userId: number;
  displayName: string;
  username: string;
  picSquare: string | null;
  channels: Map<string, ChannelInfo>;
  lastMsgAt: number;
}

/**
 * The two registries every other module in the subsystem layers on top of.
 *
 * They live in a module with no dependencies of its own deliberately. Local
 * fan-out needs both maps, and joining a channel needs channelMembers plus the
 * Redis subscription — so if either registry lived beside the code that used
 * it, transport and rooms would have to import each other.
 */
export const clients = new Map<number, ChatClient>();
export const channelMembers = new Map<string, Set<number>>();
