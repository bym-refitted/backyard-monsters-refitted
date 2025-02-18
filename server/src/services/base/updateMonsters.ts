import { Save } from "../../models/save.model";
import { ORMContext } from "../../server";

interface MonsterUpdate {
  baseid: string;
  m: any;
}

export const updateMonsters = async (monsterupdates: MonsterUpdate[]) => {
  // Fetch all bases that match the provided base IDs in one go
  const baseIds = monsterupdates.map((update) => update.baseid);
  const saves = await ORMContext.em.find(Save, { baseid: { $in: baseIds } });

  // Iterate over the saves and apply the updates
  for (const save of saves) {
    const monsterUpdate = monsterupdates.find((update) => update.baseid === save.baseid);

    if (monsterUpdate) {
      save.protected = 0;
      save.monsters = monsterUpdate.m;
    }
  }

  await ORMContext.em.flush();
};
