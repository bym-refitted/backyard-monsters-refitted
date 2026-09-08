import { AlliancePowerup } from "../../models/alliancepowerup.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import {
  powerupNotReadyErr,
  powerupRunningErr,
  powerupUnknownErr,
} from "../../errors/errors.js";
import { POWERUP_RULES, type PowerupRules } from "../../config/AllianceConfig.js";

interface Powerup {
  rules: PowerupRules;
  status: AlliancePowerup;
}

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
export const startPowerup = async (allianceId: number, powerupId: number): Promise<Powerup[]> => {
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

  return powerups;
};
