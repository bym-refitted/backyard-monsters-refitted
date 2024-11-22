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

  const thirtySixHoursAgo = currentTime - 60 * 36 * 60;
  const eightHoursAgo = currentTime - 8 * 60 * 60;
  const oneHourAgo = currentTime - 3600;

  // Check if 7 days have passed since account creation
  const isFirstWeekOver = currentTime - createtime > sevenDays;

  // Check if 12 hours have passed since outpost takeover
  const isOutpostProtectionOver = currentTime - createtime > twelveHours;

  let persist = false;

  const setProtection = () => {
    protection = 1;
    mainProtectionTime = currentTime;
    persist = true;
  };

  const removeProtection = () => {
    protection = 0;
    mainProtectionTime = null;
    save.initialProtectionOver = true;
    persist = true
  };

  const setOutpostProtection = () => {
    protection = 1;
    outpostProtectionTime = currentTime;
    persist = true;
  };

  const removeOutpostProtection = () => {
    protection = 0;
    outpostProtectionTime = null;
    save.initialOutpostProtectionOver = true;
    persist = true
  };

  if (mode === BaseMode.ATTACK) {
    protection = 0;
    save.initialProtectionOver = true;
    save.initialOutpostProtectionOver = true;
    if (mainProtectionTime) mainProtectionTime = null;
    if (outpostProtectionTime) outpostProtectionTime = null;
    persist = true;
  } else {
    switch (type) {
      case BaseType.MAIN:
        const attacksInLastHour = attackTimestamps.filter(
          (timestamp) => timestamp > oneHourAgo
        );
        // If there are new attacks after the 36-hour protection period
        // has ended, apply protection again.
        const attacksInLast36Hours = attackTimestamps.filter(
          (timestamp) => timestamp > thirtySixHoursAgo
        );

        if (protection) {
          // Should never happen
          if (!mainProtectionTime) removeProtection();

          // First week of the game = 7 DAYS
          if (isFirstWeekOver && !initialProtectionOver) removeProtection();

          // If the protection time was set over 36 hours ago, remove protection
          if (mainProtectionTime <= thirtySixHoursAgo) removeProtection();
        } else {
          // 4 attacks in 1 hour = 1 HOUR
          if (attacksInLastHour.length >= 4) {
            setProtection();
            save.attackTimestamps = save.attackTimestamps.slice(-3);
          }

          // 50% and 75% or more damage = 36 HOURS
          if (damage >= 50 && attacksInLast36Hours.length !== 0) {
            setProtection();
          }
        }
        break;
      case BaseType.OUTPOST:
        // If there are new attacks after the 8-hour protection period
        // has ended, apply protection again.
        const attacksInLast8Hours = attackTimestamps.filter(
          (timestamp) => timestamp > eightHoursAgo
        );

        if (protection) {
          // Should never happen
          if (!outpostProtectionTime) removeProtection();

          // Outpost takeover = 12 HOURS
          if (isOutpostProtectionOver && !initialOutpostProtectionOver) {
            removeOutpostProtection();
          }
          // If the protection time was set over 8 hours ago, remove protection
          if (mainProtectionTime <= eightHoursAgo) removeProtection();
        } else {
          // 25% or more damage = 8 HOURS
          if (damage >= 25 && attacksInLast8Hours.length !== 0) {
            setOutpostProtection();
          }
        }
        break;
      default:
        break;
    }
  }

  if (persist) {
    save.protected = protection;
    save.mainProtectionTime = mainProtectionTime;
    save.outpostProtectionTime = outpostProtectionTime;
    await ORMContext.em.persistAndFlush(save);
  }

  return protection;
};
