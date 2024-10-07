// FROM CLIENT: wmid
// const L_IDS = [1,2,3,4,5,6,7,8,9,10,41,42];
// const K_IDS = [11,12,13,14,15,16,17,18,19,20,43,44];
// const A_IDS = [21,22,23,24,25,26,27,28,29,30,45,46];
// const D_IDS = [31,32,33,34,35,36,37,38,39,40,47,48,101,102,103,104,105,106,107,108,109,110];

import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { getWMDefaultBase } from "../../../data/tribes";
import { Tribes } from "../../../enums/Tribes";
import { calculateTribeLevel } from "./calculateTribeLevel";

// TODO: Rewrite
export const wildMonsterSave = (baseid: string, worldId: string): Save => {
  const baseidInt = parseInt(baseid);
  const fork = ORMContext.em.fork();
  const x = Math.floor((baseidInt % 1000000) % 1000);
  const y = Math.floor((baseidInt % 1000000) % 1000);
  const tribeIndex = (x + y) % Tribes.length;
  const world_level = 10;
  const wmid = tribeIndex * 10 + 1;
  const monsterLevel = calculateTribeLevel(x, y, worldId, Tribes[tribeIndex]);
  const { save: defaultSave, level: wm_level } = getWMDefaultBase(
    tribeIndex,
    monsterLevel
  );

  const save = fork.create(Save, {
    ...defaultSave,
    basename: "",
    name: "",
    lastupdateAt: new Date(),
    createdAt: new Date(),
    homebase: [x.toString(), y.toString()],
  });
  save.basesaveid = baseidInt;
  save.baseid = baseid.toString();
  save.wmid = wmid;
  save.level = wm_level;

  return save;
};
