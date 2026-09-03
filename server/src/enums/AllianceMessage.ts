/**
 * What a row in the alliance feed represents.
 * 
 * @enum {string}
 */
export enum AllianceMessageType {
  MESSAGE = "message",
  JOINED = "joined",
  LEFT = "left",
  KICKED = "kicked",
  PROMOTED = "promoted",
  CREATED = "created",
  RELATIONSHIP = "relationship",
}

/**
 * The type of message sent to the alliance feed.
 * 
 * @enum {string}
 */
export enum ChatControlType {
  AllianceEvict = "alliance_evict",
}