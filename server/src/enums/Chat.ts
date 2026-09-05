/**
 * What kind of room a channel is, which decides where its messages are stored
 * and which name form they carry.
 *
 * @enum {string}
 */
export enum ChannelType {
  Alliance = "alliance",
  Global = "global",
}

/**
 * A command published on the chat control channel, telling the gateway to act on
 * a connection rather than deliver a message.
 *
 * @enum {string}
 */
export enum ChatControlType {
  AllianceEvict = "alliance_evict",
}
