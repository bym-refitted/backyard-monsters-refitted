import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { type FieldData, Save } from "../../../../models/save.model.js";
import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources.js";

export const attackLootHandler = (
  value: any,
  userSave: Save,
  resourceField: SaveKeys.RESOURCES | SaveKeys.IRESOURCES = SaveKeys.RESOURCES
) => {
  if (value) {
    const resources: Resources = value;
    const savedResources: FieldData = updateResources(
      resources,
      userSave[resourceField] || {}
    );
    userSave[resourceField] = savedResources;
  }
};
