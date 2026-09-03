import { AllianceMessageType } from "../enums/AllianceMessage.js";

/** Max members an alliance can hold. */
export const MAX_ALLIANCE_MEMBERS = 50;

/** Text for different types of shouts for an alliance. */
export const SHOUT_TEXT: Partial<Record<AllianceMessageType, string>> = {
  [AllianceMessageType.PROMOTED]: "has been promoted to leader.",
  [AllianceMessageType.JOINED]: "has been added to the Alliance!",
  [AllianceMessageType.KICKED]: "has been removed from the alliance.",
  [AllianceMessageType.LEFT]: "has now left the Alliance.",
  [AllianceMessageType.CREATED]: "has created the Alliance!",
};