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
    protected: protection,
    createtime,
    initialProtectionOver,
    initialOutpostProtectionOver,
    attackTimestamps,
  } = save;

  const currentTime = getCurrentDateTime();
  const oneHourAgo = currentTime - 3600;
  const sevenDays = 7 * 24 * 60 * 60;
  const twelveHours = 12 * 60 * 60;

  // Check if 7 days have passed since account creation
  const isFirstWeekOver = currentTime - createtime > sevenDays;

  // Check if 12 hours have passed since outpost takeover
  const isOutpostProtectionOver = currentTime - createtime > twelveHours;

  if (mode === BaseMode.ATTACK) protection = 0;
  else {
    switch (type) {
      case BaseType.MAIN:
        // 1. First week of the game = 7d
        if (isFirstWeekOver && !initialProtectionOver) {
          protection = 0;
          save.initialProtectionOver = true;
        }
        // 2. Four attacks in 1 hour = 1hr
        const recentAttacks = attackTimestamps.filter(
          (timestamp) => timestamp > oneHourAgo
        );

        if (recentAttacks.length >= 4) {
          protection = 1;

          // Check if the last timestamp is older than one hour, if so, reset the attack timestamps
          if (recentAttacks[recentAttacks.length - 1] <= oneHourAgo) {
            save.attackTimestamps = [];
          } else {
            save.attackTimestamps = recentAttacks;
          }
        } else {
          protection = 0;
          save.attackTimestamps = recentAttacks;
        }

        // 3. 50% and 75% or more damage = 36h
        if (damage >= 50) protection = 1;
        break;
      case BaseType.OUTPOST:
        // 1. First takeover = 12h
        if (isOutpostProtectionOver && !initialOutpostProtectionOver) {
          protection = 0;
          save.initialOutpostProtectionOver = true;
        }
        // 2. 25% damage in 2-3 attacks, instant protection on third attack = 8h
        if (damage >= 25) protection = 1;
        break;
      default:
        break;
    }
  }

  save.protected = protection;
  await ORMContext.em.persistAndFlush(save);

  return protection;
};
