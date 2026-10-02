import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { Save } from "../../../../database/models/save.model.js";
import type { BuildingData, BuildingDataMap } from "../../../../types/BuildingData.js";

enum Building {
  MONSTER_BUNKER = 22,
  TRAP = 24,
  HEAVY_TRAP = 117,
}

/**
 * Updates buildingdata after an attack in a server-authoritative way.
 *
 * Buildings are never modified by attacks — their type, level, and position
 * are taken directly from the DB, so a hacker cannot modify them by tampering
 * with the network payload.
 *
 * The only legitimate changes an attack makes to buildingdata are:
 *   - removing triggered traps (types 24 and 117), detected by their keys
 *     being absent from the client's submission
 *   - killing the monsters housed in a Monster Bunker (type 22)
 *
 * @param {BuildingDataMap | null} buildingData - The building data submitted by the attacker
 * @param {Save} save - The defender's save record
 */
export const buildingDataHandler = (buildingData: BuildingDataMap | null, save: Save) => {
  if (!buildingData) return;

  const savedBuildingData = save.buildingdata || {};

  const result: BuildingDataMap = {};

  for (const [key, building] of Object.entries(savedBuildingData)) {
    const submitted = buildingData[key];

    switch (building.t) {
      case Building.TRAP:
      case Building.HEAVY_TRAP:
        if (submitted) result[key] = building;
        break;

      case Building.MONSTER_BUNKER:
        result[key] = submitted ? updateBunkerMonsters(building, submitted.m) : building;
        break;

      default:
        result[key] = building;
    }
  }

  save[SaveKeys.BUILDINGDATA] = result;
};

/**
 * Lowers a bunker's stored monster counts to those the attacker reports as surviving.
 * Counts are never raised and creatures the bunker did not hold are ignored, so the
 * payload can only remove monsters. A destroyed bunker is exported without counts.
 *
 * @param {BuildingData} bunker - The stored bunker
 * @param {Record<string, number>} survivors - Surviving counts reported by the attacker, keyed by creature id
 * @returns {BuildingData} The bunker with its surviving monsters
 */
const updateBunkerMonsters = (bunker: BuildingData, survivors: Record<string, number> = {}): BuildingData => {
  const m: Record<string, number> = {};

  for (const [creature, count] of Object.entries(bunker.m ?? {})) {
    const remaining = Math.min(count, survivors[creature] ?? 0);

    if (remaining > 0) m[creature] = remaining;
  }

  return { ...bunker, m };
};
