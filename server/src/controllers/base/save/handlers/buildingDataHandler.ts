import { SaveKeys } from "../../../../enums/SaveKeys";
import { permissionErr } from "../../../../errors/errors";
import { Save } from "../../../../models/save.model";

enum Building {
  TRAP = 24,
  HEAVY_TRAP = 117,
}

interface BuildingData {
  x: number;      // x coordinate
  y: number;      // y coordinate
  t: number;      // type
  l?: number;     // level
}

/**
 * Handles building data validation during base attack save operations.
 *
 * This handler performs two key validation steps:
 * 1) Ensures non-trap buildings aren't removed from the base (count validation)
 * 2) Verifies that immutable properties (type, position, level) of buildings aren't modified
 *
 * Trap buildings (types 24 and 117) are specifically excluded from these validation checks
 * as they can be legitimately removed during gameplay.
 *
 * @param {Record<string, any>} buildingData - The new building data submitted by the client
 * @param {Save} save - The save object of the base to be validated
 * @returns {Promise<void>} A promise that resolves when validation is are complete
 * @throws {Error} Throws a permission error if validation fails
 */
export const buildingDataHandler = async (buildingData: Record<string, any>, save: Save) => {
  const savedBuildingData = save.buildingdata || {};
  const buildingKeys = ["x", "y", "t", "l"];

  let originalBuildingCount = 0;
  let newBuildingCount = 0;

  for (const key in buildingData) {
    const building: BuildingData = buildingData[key];

    if (building.t === Building.TRAP || building.t === Building.HEAVY_TRAP) 
      continue;

    newBuildingCount++;
  }

  for (const key in savedBuildingData) {
    const building: BuildingData = savedBuildingData[key];

    if (building.t === Building.TRAP || building.t === Building.HEAVY_TRAP) 
      continue;

    originalBuildingCount++;

    // Validate that building data from db exists in client data
    const newBuilding = buildingData[key];
    if (!newBuilding) throw permissionErr();

    // Validate immutable properties
    for (const key of buildingKeys) {
      if (
        building[key] !== undefined &&
        (newBuilding[key] === undefined ||
          newBuilding[key] !== building[key])
      ) {
        throw permissionErr();
      }
    }
  }

  if (newBuildingCount < originalBuildingCount) throw permissionErr();

  // Validation passed
  save[SaveKeys.BUILDINGDATA] = buildingData;
};
