import { BaseMode, BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";

/**
 * TODO: Implement Damage Protection for Main Yards and Outposts
 * Wiki: https://backyardmonsters.fandom.com/wiki/Damage_Protection
 * */
export const damageProtection = async (save: Save, mode?: BaseMode) => {
  const { type, damage } = save;
  let isCellProtected = save.protected;

  if (mode === BaseMode.ATTACK) isCellProtected = 0;
  else {
    switch (type) {
      case BaseType.MAIN:
        if (damage >= 50) isCellProtected = 1;
        break;
      case BaseType.OUTPOST:
        if (damage >= 25) isCellProtected = 1;
        break;
      default:
        break;
    }
  }

  save.protected = isCellProtected;
  await ORMContext.em.persistAndFlush(save);

  return isCellProtected;
};