import { BaseMode, BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

/**
 * Wiki: https://backyardmonsters.fandom.com/wiki/Damage_Protection
 */

// Current broken scenarios:
// 1. When a base gets attacked 4 times or more, then protection is reset, attacked again, user comes and repairs the base => protection is stuck at 1
// 2. Outposts are similar to the above, after taking over someone's outpost, protection is stuck at 1
export const damageProtection = async (save: Save, mode?: BaseMode) => {
  let {
    type,
    damage,
    createtime,
    initialProtectionOver,
    initialOutpostProtectionOver,
    attackTimestamps,
    outpostProtectionTime,
    mainProtectionTime,
  } = save;

  let protection = save.protected;
  const currentTime = getCurrentDateTime();

  const sevenDays = 7 * 24 * 60 * 60;
  const twelveHours = 12 * 60 * 60;

  const thirtySixHoursAgo = currentTime - 36 * 60 * 60;
  const eightHoursAgo = currentTime - 8 * 60 * 60;
  const oneHourAgo = currentTime - 3600;

  // Check if 7 days have passed since account creation
  const isFirstWeekOver = currentTime - createtime > sevenDays;

  // Check if 12 hours have passed since outpost takeover
  const isOutpostProtectionOver = currentTime - createtime > twelveHours;

  if (mode === BaseMode.ATTACK) {
    protection = 0;
    if (mainProtectionTime) mainProtectionTime = null;
  } else {
    switch (type) {
      case BaseType.MAIN:
        // ======================================
        // First week of the game = 7 DAYS
        // ======================================
        if (isFirstWeekOver && !initialProtectionOver) {
          protection = 0;
          save.initialProtectionOver = true;
        }

        // ======================================
        // 4 attacks in 1 hour = 1 HOUR
        // ======================================
        const recentAttacks = attackTimestamps.filter(
          (timestamp) => timestamp > oneHourAgo
        );

        console.log("Checker: Recent attacks", recentAttacks.length);

        if (recentAttacks.length >= 4) {
          protection = 1;

          if (recentAttacks[recentAttacks.length - 1] <= oneHourAgo) {
            save.attackTimestamps = [];
          } else {
            save.attackTimestamps = recentAttacks;
          }
        }

        // ======================================
        // 50% and 75% or more damage = 36 HOURS
        // ======================================
        if (damage >= 50) {
          if (mainProtectionTime && mainProtectionTime <= thirtySixHoursAgo) {
            protection = 0;
          } else {
            protection = 1;
            mainProtectionTime = currentTime;
          }

          // If there are new attacks after the 36-hour protection period
          // has ended, apply protection again.
          const recentYardAttacks = attackTimestamps.filter(
            (timestamp) => timestamp > thirtySixHoursAgo
          );

          if (recentYardAttacks.length > 0) {
            protection = 1;
            mainProtectionTime = currentTime;
          }
        }
        break;
      case BaseType.OUTPOST:
        // ======================================
        // Outpost takeover = 12 HOURS
        // ======================================
        if (isOutpostProtectionOver && !initialOutpostProtectionOver) {
          protection = 0;
          save.initialOutpostProtectionOver = true;
        }

        // ======================================
        // 25% damage in 2-3 attacks, instant protection on third attack = 8 HOURS
        // ======================================
        if (damage >= 25) {
          if (outpostProtectionTime && outpostProtectionTime <= eightHoursAgo) {
            protection = 0;
          } else {
            protection = 1;
            outpostProtectionTime = currentTime;
          }

          // If there are new attacks after the 8-hour protection period
          // has ended, apply protection again.
          const recentOutpostAttacks = attackTimestamps.filter(
            (timestamp) => timestamp > eightHoursAgo
          );

          if (recentOutpostAttacks.length > 0) {
            protection = 1;
            outpostProtectionTime = currentTime;
          }
        }
        break;
      default:
        break;
    }
  }

  save.protected = protection;
  save.mainProtectionTime = mainProtectionTime;
  save.outpostProtectionTime = outpostProtectionTime;
  await ORMContext.em.persistAndFlush(save);

  return protection;
};
