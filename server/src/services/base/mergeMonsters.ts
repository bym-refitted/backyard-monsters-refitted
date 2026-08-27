import type { JsonObject } from "../../types/JsonObject.js";

interface CreepInfo {
  health: number;
  ownerID: number;
  q: number;
}

const HEAL_QUEUE_KEY = "Q";

const isCreepArray = (value: unknown): value is CreepInfo[] => Array.isArray(value);

/**
 * Reads a creep's health, rejecting anything that isn't a real number.
 *
 * @param {unknown} value - The raw health field from either roster
 * @returns {number | null} The health, or null if it cannot be trusted
 */
const toHealth = (value: unknown): number | null =>
  typeof value === "number" && Number.isFinite(value) ? value : null;

/**
 * Merges an MR3 monster roster reported by an attacking client into the stored one.
 *
 * The client sends its whole roster on every attack save, built from a snapshot taken
 * when it last loaded the main yard. If that snapshot is written back verbatim it
 * silently reverts anything the server recorded in the meantime - most importantly the
 * defending monster losses written when someone attacked the player's yard while they
 * were out farming.
 *
 * So across an attack save a creep's health may only fall. Each slot keeps whichever of
 * the two states is the more damaged, which lets the attack the client just fought
 * through while leaving losses it never saw intact. Creatures the client reports but the
 * server has no record of are dropped.
 *
 * @param {JsonObject | null | undefined} stored - The roster currently held on the save
 * @param {JsonObject} reported - The roster reported by the attacking client
 * @returns {JsonObject} The reconciled roster to persist
 */
export const mergeMonsters = (stored: JsonObject | null | undefined, reported: JsonObject) => {
  if (!stored || Object.keys(stored).length === 0) return reported;

  const merged: JsonObject = {};

  for (const [creatureID, storedSlots] of Object.entries(stored)) {
    if (creatureID === HEAL_QUEUE_KEY) continue;

    const reportedSlots = reported[creatureID];

    if (!isCreepArray(storedSlots) || !isCreepArray(reportedSlots)) {
      merged[creatureID] = storedSlots;
      continue;
    }

    merged[creatureID] = storedSlots.map((storedCreep, index) => {
      const reportedCreep = reportedSlots[index];

      if (!reportedCreep) return storedCreep;

      const storedHealth = toHealth(storedCreep?.health);
      const reportedHealth = toHealth(reportedCreep.health);

      if (reportedHealth === null) return storedCreep;
      if (storedHealth === null) return reportedCreep;

      return reportedHealth < storedHealth ? reportedCreep : storedCreep;
    });
  }

  if (reported[HEAL_QUEUE_KEY])
    merged[HEAL_QUEUE_KEY] = reported[HEAL_QUEUE_KEY];

  return merged;
};
