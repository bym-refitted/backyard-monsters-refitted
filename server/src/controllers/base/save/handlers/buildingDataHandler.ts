import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { Save } from "../../../../models/save.model.js";

enum Building {
  TRAP = 24,
  HEAVY_TRAP = 117,
}

/**
 * Updates buildingdata after an attack in a server-authoritative way.
 *
 * Non-trap buildings are never modified by attacks — their type, level, and
 * position are taken directly from the DB, so a hacker cannot modify them
 * by tampering with the network payload.
 *
 * The only legitimate change an attack makes to buildingdata is removing
 * triggered traps (types 24 and 117). We detect which traps were triggered
 * by checking which trap keys are absent from the client's submission.
 *
 * @param {Record<string, any> | null} buildingData - The building data submitted by the attacker
 * @param {Save} save - The defender's save record
 */
export const buildingDataHandler = (buildingData: Record<string, any> | null, save: Save) => {
  if (!buildingData) return;

  const savedBuildingData = save.buildingdata || {};

  const result: Record<string, any> = {};

  for (const key in savedBuildingData) {
    const building = savedBuildingData[key];
    const isTrap = building.t === Building.TRAP || building.t === Building.HEAVY_TRAP;

    if (isTrap) {
      // Keep the trap only if the client still reports it as present.
      // Absent = triggered during the attack, so we drop it.
      if (buildingData[key]) result[key] = building;
    } else {
      // Non-trap buildings are never modified by attacks - always keep DB value.
      result[key] = building;
    }
  }

  save[SaveKeys.BUILDINGDATA] = result;
};
