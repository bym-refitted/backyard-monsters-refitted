/**
 * Role a player holds within their alliance. Permissions
 * are derived from this in code rather than stored.
 * @enum {string}
 */
export enum AllianceRole {
  LEADER = "leader",
  OFFICER = "officer",
  MEMBER = "member",
}
