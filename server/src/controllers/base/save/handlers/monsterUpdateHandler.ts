import { Save } from "../../../../models/save.model";
import { updateMonsters } from "../../../../services/base/updateMonsters";

export const monsterUpdateHandler = async (value: any, userSave: Save) => {
  if (value && Array.isArray(value) && value.length > 0) {
    const authMonsters = value.find(({ baseid }) => baseid == userSave.baseid);

    const monsterUpdates = value.filter(
      ({ baseid }) => baseid != userSave.baseid
    );

    if (authMonsters) userSave.monsters = authMonsters.m;

    if (monsterUpdates.length > 0) await updateMonsters(monsterUpdates);
  }
};
