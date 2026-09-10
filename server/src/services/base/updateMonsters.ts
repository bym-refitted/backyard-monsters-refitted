import type { MonsterUpdate } from "../../controllers/base/save/handlers/monsterUpdateHandler.js";
import { Save } from "../../models/save.model.js";
import { postgres } from "../../server.js";

/**
 * Applies MR2 cell roster updates for bases other than the player's own main yard —
 * their outposts and map cells, whose monsters move as they fling from them.
 *
 * The baseids come from the attacking client, so the lookup is scoped to saves the
 * caller owns.
 *
 * @param {MonsterUpdate[]} monsterupdates - Cell updates reported by the client
 * @param {number} saveuserid - The owner the updated saves must belong to
 */
export const updateMonsters = async (monsterupdates: MonsterUpdate[], saveuserid: number) => {
  // Fetch all bases that match the provided base IDs in one go
  const baseIds = monsterupdates.map((update) => update.baseid.toString());
  const saves = await postgres.em.find(Save, { baseid: { $in: baseIds }, saveuserid });

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
