import { MapRoomVersion } from "../enums/MapRoom.js";

export const INFERNO_CHAT_CHANNEL = "chat:inferno-global";

export const ALLIANCE_CHANNEL_ALIAS = "alliance";

export const ALLIANCE_CHANNEL_PREFIX = "chat:alliance:";

export const CHANNELS: Record<number, string> = {
  [MapRoomVersion.V1]: "chat:mr1-global",
  [MapRoomVersion.V2]: "chat:mr2-global",
  [MapRoomVersion.V3]: "chat:mr3-global",
};