import { Save } from "../../../../models/save.model";
import { updateMonsters } from "../../../../services/base/updateMonsters";

export interface MonsterUpdate {
  m: {
    housed: {};
    hid: [];
    space: number;
    hcc: [];
    overdrivetime: number;
    h: [];
    hstage: [];
    hcount: number;
    saved: number;
  };
  baseid: number;
}

export const monsterUpdateHandler = async (
  monsters: MonsterUpdate[],
  userSave: Save
) => {
  if (monsters.length > 0) {
    const authMonsters = monsters.find(
      ({ baseid }) => baseid.toString() === userSave.baseid
    );

    const monsterUpdates = monsters.filter(
      ({ baseid }) => baseid.toString() != userSave.baseid
    );

    if (authMonsters) userSave.monsters = authMonsters.m;

    if (monsterUpdates.length > 0) await updateMonsters(monsterUpdates);
  }
};
