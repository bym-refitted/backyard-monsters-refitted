/**
 * Enum representing the states of an invitation to move onto a player's outpost.
 *
 * @enum {string}
 */
export enum MigrateStatus {
  REQUESTED = "requested",
  ACCEPTED = "accepted",
  REJECTED = "rejected",
  REVOKED = "revoked",
}
