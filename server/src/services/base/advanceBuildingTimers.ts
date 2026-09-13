import type { BuildingData, BuildingDataMap, BuildingHealthData } from "../../types/BuildingData.js";

/** DISCLAIMER:
 * ====================================================================
 * This is absolutely horrifc stuff and should be NSFW and labelled a crime. It will be changed in the future,
 * We need to handle buildingdata this way on the server because the client simulates the base over time:
 *
 *   - A base is stored as one snapshot plus a single savetime. Countdowns (cU/cB/cF) are the
 *     time remaining as of that savetime, and whoever loads the base (owner or attacker)
 *     replays it forward from there.
 *   - Attack saves don't trust the attacker's buildingdata (buildingDataHandler keeps the DB
 *     copy), but they do store the attacker's buildinghealthdata, taken at the time of the attack.
 *   - After an attack the stored base therefore mixes two moments: timers from the owner's
 *     last save, health from the attack. A single savetime can't describe both.
 *   - Leaving savetime at the owner's save heals damage early, because repairs replay over
 *     time before the attack happened. Moving it to the attack loses the owner's timer progress.
 *
 * So attack saves move savetime to the attack, and this brings the countdowns forward to match.
 * Resource production over the same gap is still not credited.
 *
 * The proper fix is server-authoritative timers: absolute timestamps with pause tracking, with the
 * server owning completion, repairs and production, and legacy cU/cB/hp derived on load for
 * older clients.
 * ====================================================================
 */

type HealthData = BuildingHealthData | null | undefined;

/**
 * The client caps its load replay at 30 days (BASE.as), so a save never credits more than that.
 */
const MAX_ELAPSED_SECONDS = 60 * 60 * 24 * 30;

/**
 * Brings a base's stored build, upgrade and fortify countdowns forward by the time since its last save.
 *
 * @param {BuildingDataMap} buildingData - Stored buildingdata, as of the last save
 * @param {BuildingHealthData | null | undefined} healthData - Stored buildinghealthdata, as of the same save
 * @param {number} elapsed - Seconds since the last save
 * @returns {BuildingDataMap} New buildingdata with the countdowns advanced
 */
export const advanceBuildingTimers = (buildingData: BuildingDataMap, healthData: HealthData, elapsed: number,): BuildingDataMap => {
  const seconds = Math.min(Math.max(Math.floor(elapsed), 0), MAX_ELAPSED_SECONDS);
  const result: BuildingDataMap = {};

  for (const [key, stored] of Object.entries(buildingData)) {
    const building: BuildingData = { ...stored };
    
    result[key] = building;

    if (seconds === 0 || isCountdownPaused(building, healthData)) continue;

    if (building.cU) {
      building.cU -= seconds;

      if (building.cU <= 0) {
        delete building.cU;
        building.l = (building.l || 1) + 1;
      }
    } else if (building.cB) {
      building.cB -= seconds;

      if (building.cB <= 0) {
        delete building.cB;
        if (building.prefab) building.l = building.prefab;
        delete building.prefab;
      }
    } else if (building.cF) {
      building.cF -= seconds;

      if (building.cF <= 0) {
        delete building.cF;
        building.fort = (building.fort ?? 0) + 1;
      }
    }
  }

  return result;
};

/**
 * Whether a building's countdown was paused as of the last save. The client only counts down buildings
 * at full health that are not repairing; damaged buildings have an entry in buildinghealthdata, and
 * outside MR3 also an hp field in buildingdata.
 *
 * @param {BuildingData} building - The stored building
 * @param {BuildingHealthData | null | undefined} healthData - Stored buildinghealthdata, as of the same save
 * @returns {boolean} True if the building was damaged or repairing
 */
const isCountdownPaused = (building: BuildingData, healthData: HealthData) =>
  Boolean(building.rE) || building.hp != null || (healthData != null && String(building.id) in healthData);
