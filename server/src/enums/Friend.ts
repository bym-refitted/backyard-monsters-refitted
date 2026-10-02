/**
 * Where a friendship stands. There is no declined state: declining, cancelling
 * and unfriending all delete the row, so a refusal leaves nothing behind for
 * the other player to see.
 *
 * @enum {string}
 */
export enum FriendshipStatus {
  PENDING = "pending",
  ACCEPTED = "accepted",
}

/**
 * How a player in search results relates to the player searching, so the
 * launcher can label the button beside them.
 *
 * @enum {string}
 */
export enum FriendRelation {
  NONE = "none",
  PENDING_INCOMING = "pending_incoming",
  PENDING_OUTGOING = "pending_outgoing",
  FRIENDS = "friends",
}
