import { BaseMode, BaseType } from "../../../enums/Base.js";
import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

/**
 * Handles the damage protection for the user's base.
 * Wiki: https://backyardmonsters.fandom.com/wiki/Damage_Protection
 *
 * @param {Save} save - The save data object.
 * @param {BaseMode} [mode] - The mode of the base (optional).
 */
export const damageProtection = async (save: Save, mode?: BaseMode) => {
  let { type, damage, attacks } = save;

  let protection = save.protected;
  const currentTime = getCurrentDateTime();

  const thirtySixHours = 36 * 60 * 60;
  const eightHours = 8 * 60 * 60;
  const oneHour = 3600;

  const thirtySixHoursAgo = currentTime - thirtySixHours;
  const eightHoursAgo = currentTime - eightHours;
  const oneHourAgo = currentTime - oneHour;

  let persist = false;

  const setProtection = (duration: number) => {
    protection = currentTime + duration;
    persist = true;
  };

  if (mode === BaseMode.ATTACK || mode === BaseMode.IATTACK) {
    protection = 0;
    persist = true;
  } else {
    switch (type) {
      case BaseType.MAIN:
        // Filter attacks after the 1-hour protection period
        const attacksInLastHour = attacks.filter(
          (attack) => attack.starttime > oneHourAgo
        );
        // Filter attacks after the 36-hour protection period
        const attacksInLast36Hours = attacks.filter(
          (attack) => attack.starttime > thirtySixHoursAgo
        );

        const isProtected = protection > 0 && protection > currentTime;

        if (!isProtected) {
          // Clear expired protection timestamp
          if (protection > 0 && protection <= currentTime) {
            protection = 0;
            persist = true;
          }

          // 4 attacks in 1 hour = 1 HOUR
          if (attacksInLastHour.length >= 4) setProtection(oneHour);

          // 50% and 75% or more damage = 36 HOURS
          if (damage >= 50 && attacksInLast36Hours.length !== 0) {
            setProtection(thirtySixHours);
          }
        }
        break;

      case BaseType.OUTPOST:
        // If there are new attacks after the 8-hour protection period
        // has ended, apply protection again.
        const attacksInLast8Hours = attacks.filter(
          (attack) => attack.starttime > eightHoursAgo
        );

        const isOutpostProtected = protection > 0 && protection > currentTime;

        if (!isOutpostProtected) {
          // Clear expired protection timestamp
          if (protection > 0 && protection <= currentTime) {
            protection = 0;
            save.damage = 0; 
            persist = true;
          }

          // 25% or more damage = 8 HOURS
          if (damage >= 25 && attacksInLast8Hours.length !== 0) {
            setProtection(eightHours);
          }
        }
        break;

      case BaseType.INFERNO:
        // Filter attacks after the 36-hour protection period
        const infernoAttacksInLast36Hours = attacks.filter(
          (attack) => attack.starttime > thirtySixHoursAgo
        );

        const isInfernoProtected = protection > 0 && protection > currentTime;

        if (!isInfernoProtected) {
          // Clear expired protection timestamp
          if (protection > 0 && protection <= currentTime) {
            protection = 0;
            persist = true;
          }

          // 50% or more damage = 36 HOURS
          if (damage >= 50 && infernoAttacksInLast36Hours.length !== 0) {
            setProtection(thirtySixHours);
          }
        }
        break;
      default:
        throw new Error(`Unknown base type for damage protection: ${type}`);
    }
  }

  if (persist) {
    save.protected = protection;
    await postgres.em.persistAndFlush(save);
  }
};
