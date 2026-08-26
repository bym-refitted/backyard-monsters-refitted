/**
 * Which side opened the exchange. A leader inviting a player and a player asking
 * to join an alliance are the same record; only the originator differs, and that
 * decides who sees it in their Invites tab and what the dialog offers them.
 * 
 * @enum {string}
 */
export enum AllianceInviteType {
  INVITE = "invite",
  REQUEST = "request",
}

/**
 * Where an invite stands. Resolving one is what notifies the originator: a
 * pending row is shown to the counterparty, and once accepted or declined the
 * same row becomes the outcome notice shown back to whoever started it.
 * 
 * @enum {string}
 */
export enum AllianceInviteStatus {
  PENDING = "pending",
  ACCEPTED = "accepted",
  DECLINED = "declined",
}
