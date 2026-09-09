import { AllianceMessageType, AlliancePowerupType, AllianceStance } from "../enums/Alliance.js";

export interface PowerupRules {
  powerup_id: number;
  type: AlliancePowerupType;
  running_time: number;
  recharge_time: number;
  hourly_cost: number;
}

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

/** The label each flag renders as. */
export const STANCE_LABEL: Record<AllianceStance, string> = {
  [AllianceStance.HOSTILE]: "Foe",
  [AllianceStance.NEUTRAL]: "Neutral",
  [AllianceStance.FRIENDLY]: "Ally",
};

/**
 * The rules governing each alliance power-up - how long it runs once started, how
 * long it takes to charge, and what an hour off that charge costs in Shiny.
 */
export const POWERUP_RULES: PowerupRules[] = [
  {
    powerup_id: 1,
    type: AlliancePowerupType.ARMAMENT,
    running_time: 12 * 3600,
    recharge_time: 7 * 24 * 3600,
    hourly_cost: 20,
  },
  {
    powerup_id: 2,
    type: AlliancePowerupType.CONQUEST,
    running_time: 6 * 3600,
    recharge_time: 5 * 24 * 3600,
    hourly_cost: 20,
  },
  {
    powerup_id: 3,
    type: AlliancePowerupType.DECLARE_WAR,
    running_time: 12 * 3600,
    recharge_time: 7 * 24 * 3600,
    hourly_cost: 20,
  },
];

/** How each power-up is named in a shout - the original's ap_*_name values. */
export const POWERUP_LABEL: Record<AlliancePowerupType, string> = {
  [AlliancePowerupType.ARMAMENT]: "Armament",
  [AlliancePowerupType.CONQUEST]: "Conquest",
  [AlliancePowerupType.DECLARE_WAR]: "Declare War",
};