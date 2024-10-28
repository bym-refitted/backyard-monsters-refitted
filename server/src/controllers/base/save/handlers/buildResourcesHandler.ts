import { Save } from "../../../../models/save.model";

/**
 * Handles the building resources logic.
 *
 * @param {Save} save - The save object.
 * @param {Save} userSave - The user save object.
 * @param {boolean} isOutpost - Whether the save is an outpost.
 */
export const buildingResourcesHandler = (
  save: Save,
  userSave: Save,
  isOutpost: boolean
) => {
  if (isOutpost) {
    userSave.buildingresources[`b${save.baseid}`] =
      save.buildingresources[`b${save.baseid}`];
  }
};
