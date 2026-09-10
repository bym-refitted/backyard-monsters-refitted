/**
 * Role a player holds within their alliance. Permissions
 * are derived from this in code rather than stored.
 * @enum {string}
 */
export enum AllianceRole {
  LEADER = "leader",
  MEMBER = "member",
}

/**
 * How one alliance has flagged another - Foe, Neutral or Ally.
 *
 * @enum {number}
 */
export enum AllianceStance {
  HOSTILE = -1,
  NEUTRAL = 0,
  FRIENDLY = 1,
}

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
  POWERUP_ACTIVATED = "powerup_activated",
  POWERUP_PURCHASE = "powerup_purchase",
}

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

/**
 * The three alliance power-ups. Values are the ids the client's POWERUPS class
 * keys its buckets by, so they must match `ap_*` in POWERUPS.as exactly.
 *
 * @enum {string}
 */
export enum AlliancePowerupType {
  ARMAMENT = "ap_armament",
  CONQUEST = "ap_conquest",
  DECLARE_WAR = "ap_declarewar",
}
