import { BaseMode, BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

/**
 * TODO: Currently damage protection is only tracked when a user logs in, e.g. triggers baseLoad.
 * Wiki: https://backyardmonsters.fandom.com/wiki/Damage_Protection
 * */
export const damageProtection = async (save: Save, mode?: BaseMode) => {
  let {
    type,
    damage,
    createtime,
    initialProtectionOver,
    initialOutpostProtectionOver,
    attackTimestamps,
    protectionSetTime,
  } = save;

  let protection = save.protected;

  const currentTime = getCurrentDateTime();
  const sevenDays = 7 * 24 * 60 * 60;
  const twelveHours = 12 * 60 * 60;

  const thirtySixHoursAgo = currentTime - 36 * 60 * 60;
  const oneHourAgo = currentTime - 3600;

  // Check if 7 days have passed since account creation
  const isFirstWeekOver = currentTime - createtime > sevenDays;

  // Check if 12 hours have passed since outpost takeover
  const isOutpostProtectionOver = currentTime - createtime > twelveHours;

  if (mode === BaseMode.ATTACK) protection = 0;
  else {
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
        if (protectionSetTime <= thirtySixHoursAgo) {
          protection = 0;
          protectionSetTime = null;
        }

        if (damage >= 50) {
          protection = 1;
          protectionSetTime = currentTime;                             
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
        if (damage >= 25) protection = 1;
        break;
      default:
        break;
    }
  }

  save.protected = protection;
  save.protectionSetTime = protectionSetTime;
  await ORMContext.em.persistAndFlush(save);

  return protection;
};
