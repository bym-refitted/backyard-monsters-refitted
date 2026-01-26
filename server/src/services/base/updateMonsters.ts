import type { MonsterUpdate } from "../../controllers/base/save/handlers/monsterUpdateHandler.js";
import { Save } from "../../models/save.model.js";
import { postgres } from "../../server.js";

export const updateMonsters = async (monsterupdates: MonsterUpdate[]) => {
  // Fetch all bases that match the provided base IDs in one go
  const baseIds = monsterupdates.map((update) => update.baseid.toString());
  const saves = await postgres.em.find(Save, { baseid: { $in: baseIds } });

  // Iterate over the saves and apply the updates
  for (const save of saves) {
    const monsterUpdate = monsterupdates.find(
      (update) => update.baseid.toString() === save.baseid
    );

    if (monsterUpdate) {
      save.protected = 0;
      save.monsters = monsterUpdate.m;
    }
  }
};
