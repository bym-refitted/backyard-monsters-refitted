import { SaveKeys } from "../../../../enums/SaveKeys";
import { permissionErr } from "../../../../errors/errors";
import { Save } from "../../../../models/save.model";

enum Building {
  TRAP = 24,
  HEAVY_TRAP = 117,
}

interface BuildingData {
  x: number;        // x coordinate
  y: number;        // y coordinate
  t: number;        // type
}

/**
 * Handles building data validation during base attack save operations.
 *
 * This handler ensures that essential buildings aren't removed from the base.
 * It allows trap buildings (types 24 and 117) to be removed, as this is
 * expected gameplay behavior, but prevents other building types from decreasing in count.
 *
 * @param {Record<string, any>} buildingData - The new building data submitted by the client
 * @param {Save} save - The save object of the base to be validated
 * @returns {Promise<void>} A promise that resolves when validation is are complete
 * @throws {Error} Throws a permission error if validation fails
 */
export const buildingDataHandler = async (buildingData: Record<string, any>, save: Save) => {
  const savedBuildingData = save.buildingdata || {};

  let originalBuildingCount = 0;
  let newBuildingCount = 0;

  for (const key in savedBuildingData) {
    const building: BuildingData = savedBuildingData[key];

    if (building.t !== Building.TRAP && building.t !== Building.HEAVY_TRAP) {
      originalBuildingCount++;
    }
  }

  for (const key in buildingData) {
    const building: BuildingData = buildingData[key];

    if (building.t !== Building.TRAP && building.t !== Building.HEAVY_TRAP) {
      newBuildingCount++;
    }
  }

  if (newBuildingCount < originalBuildingCount) throw permissionErr();

  // TODO: Implement a more robust validation for building data

  save[SaveKeys.BUILDINGDATA] = buildingData;
};
