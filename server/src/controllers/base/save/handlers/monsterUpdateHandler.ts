import { Save } from "../../../../models/save.model.js";
import { updateMonsters } from "../../../../services/base/updateMonsters.js";

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

/**
 * Handles the `monsterupdate` save key after an attack, persisting monster state
 * back to the attacking player's save. Branches on format to support both map versions.
 *
 * MR3: The client sends a plain object keyed by creatureID, where each value is an array
 * of per-creep state objects `{ health, ownerID, q }`, with an optional `Q` heal queue.
 * This is written directly to `userSave.monsters` so damaged monsters persist and heal
 * in the main yard over time.
 *
 * MR2: The client sends an array of cell updates `[{ baseid, m: housingState }, ...]`.
 * The entry matching the attacker's baseid updates `userSave.monsters`; remaining entries
 * update other bases (e.g. outpost housing) via `updateMonsters`.
 *
 * @param {MonsterUpdate[] | Record<string, unknown>} monsters - Parsed monsterupdate payload
 * @param {Save} userSave - The attacking user's save to update
 */
export const monsterUpdateHandler = async (
  monsters: MonsterUpdate[] | Record<string, unknown>,
  userSave: Save
) => {
  if (!Array.isArray(monsters)) {
    userSave.monsters = monsters;
    return;
  }

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
