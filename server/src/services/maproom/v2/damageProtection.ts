import { BaseMode, BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

/**
 * TODO: Implement Damage Protection for Main Yards and Outposts
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
  } = save;

  const currentTime = getCurrentDateTime();
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
        // Protection scenarios:
        // 1. First week of the game = 7d
        if (isFirstWeekOver && !initialProtectionOver) {
          protection = 0;
          save.initialProtectionOver = true;
        }
        // 2. 4 attacks in 1 hour = 1hr
        // 3. 50% and 75% or more damage = 36h
        if (damage >= 50) protection = 1;
        break;
      case BaseType.OUTPOST:
        // Protection scenarios:
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
