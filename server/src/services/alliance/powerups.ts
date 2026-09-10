import { AllianceMessageType, AlliancePowerupType } from "../../enums/Alliance.js";
import { AlliancePowerup } from "../../database/models/alliancepowerup.model.js";
import { Save } from "../../database/models/save.model.js";
import type { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import {
  notEnoughShinyErr,
  powerupNotReadyErr,
  powerupReadyErr,
  powerupRunningErr,
  powerupUnknownErr,
} from "../../errors/errors.js";
import { POWERUP_RULES, type PowerupRules } from "../../config/AllianceConfig.js";
import { announceShout } from "./allianceMessages.js";

interface Powerup {
  rules: PowerupRules;
  status: AlliancePowerup;
}

export interface PowerupPurchase {
  allianceId: number;
  author: User;
  userSave: PayingSave;
  powerupId: number;
  hours: number;
}

export interface PowerupActivation {
  allianceId: number;
  author: User;
  powerupId: number;
}


interface RunningPowerup {
  id: AlliancePowerupType;
  endtime: number;
}

type PayingSave = Pick<Save, "credits">;

/**
 * Loads an alliance's power-ups, seeding and expiring them as it goes.
 
 * A power-up an alliance has never held is created charging from now rather than
 * from the alliance's creation date, so alliances that predate this table start a
 * charge instead of appearing instantly ready.
 *
 * @param {number} allianceId - The alliance whose power-ups are being read.
 * @returns {Promise<Powerup[]>} All three power-ups, in tab order.
 */
export const alliancePowerup = async (allianceId: number): Promise<Powerup[]> => {
  const rows = await postgres.em.find(AlliancePowerup, { alliance_id: allianceId });

  const now = getCurrentDateTime();

  const powerups = POWERUP_RULES.map((rules) => {
    let status = rows.find((row) => row.powerup === rules.type);

    if (!status) {
      status = postgres.em.create(AlliancePowerup, {
        alliance_id: allianceId,
        powerup: rules.type,
        active: false,
        end_time: now + rules.recharge_time,
        updated_at: new Date(),
      });

      postgres.em.persist(status);
    } else if (status.active && status.end_time <= now) {
      status.active = false;
      status.end_time += rules.recharge_time;
    }

    return { rules, status };
  });

  await postgres.em.flush();

  return powerups;
};

/**
 * Starts a charged power-up, buffing every member of the alliance for its running time.
 *
 * @param {number} allianceId - The alliance starting it.
 * @param {number} powerupId - Which power-up, from the getpowerups rows.
 * @returns {Promise<Powerup[]>} All the alliance's power-ups, the started one updated.
 * @throws {ClientSafeError} When the id is unknown, or it is already running or still charging.
 */
export const startPowerup = async ({ allianceId, author, powerupId }: PowerupActivation): Promise<Powerup[]> => {
  const powerups: Powerup[] = await alliancePowerup(allianceId);

  const powerup = powerups.find(({ rules }) => rules.powerup_id === powerupId);
  
  if (!powerup) throw powerupUnknownErr();

  const { rules, status } = powerup;
  const now = getCurrentDateTime();

  if (status.active) throw powerupRunningErr();
  if (status.end_time > now) throw powerupNotReadyErr();

  status.active = true;
  status.end_time = now + rules.running_time;

  await postgres.em.flush();

  await announceShout({
    allianceId,
    author,
    type: AllianceMessageType.POWERUP_ACTIVATED,
    body: rules.type,
  });

  return powerups;
};

/**
 * Spends Shiny to bring a charging power-up closer to ready.
 *
 * @param {PowerupPurchase} purchase - Alliance, paying save, power-up and hours asked for.
 * @returns {Promise<Powerup[]>} All the alliance's power-ups, the sped-up one updated.
 * @throws {ClientSafeError} When the id is unknown, it is running or already charged, or Shiny is short.
 */
export const reducePowerupCharge = async ({ allianceId, author, userSave, powerupId, hours }: PowerupPurchase) => {
  const powerups = await alliancePowerup(allianceId);

  const powerup = powerups.find(({ rules }) => rules.powerup_id === powerupId);
  if (!powerup) throw powerupUnknownErr();

  const { rules, status } = powerup;
  const now = getCurrentDateTime();

  if (status.active) throw powerupRunningErr();

  if (status.end_time <= now) throw powerupReadyErr();

  const remainingHours = Math.ceil((status.end_time - now) / 3600);
  const boughtHours = Math.min(hours, remainingHours);

  const cost = boughtHours * rules.hourly_cost;

  if (userSave.credits < cost) throw notEnoughShinyErr();

  userSave.credits -= cost;

  status.end_time = Math.max(now, status.end_time - boughtHours * 3600);

  await postgres.em.flush();

  await announceShout({
    allianceId,
    author,
    type: AllianceMessageType.POWERUP_PURCHASE,
    body: JSON.stringify({ powerup: rules.type, hours: boughtHours }),
  });

  return powerups;
};

/**
 * The alliance's running power-ups, in the shape base load hands the client.
 *
 * @param {User["alliance_id"]} allianceId - The viewing player's alliance, if any.
 * @returns {Promise<RunningPowerup[]>} Rows for POWERUPS.Setup.
 */
export const runningPowerups = async (allianceId: User["alliance_id"]): Promise<RunningPowerup[]> => {
  if (!allianceId) return [];

  const now = getCurrentDateTime();
  const powerups = await alliancePowerup(allianceId);

  return powerups
    .filter(({ status }) => status.active && status.end_time > now)
    .map(({ status }) => ({ id: status.powerup, endtime: status.end_time }));
};
