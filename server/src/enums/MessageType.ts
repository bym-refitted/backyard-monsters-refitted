/**
 * Enum representing the types of messages that can be sent between players.
 * @enum {string}
 */
export enum MessageType {
  MESSAGE = "message",
  TRUCE_REQUEST = "trucerequest",
  TRUCE_ACCEPT = "truceaccept",
  TRUCE_REJECT = "trucereject",
  MIGRATE_REQUEST = "migraterequest",
}
