import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { Save } from "../../../../models/save.model.js";
import type { JsonObject } from "../../../../types/JsonObject.js";
import {
  type Resources,
  updateResources,
} from "../../../../services/base/updateResources.js";

export const attackLootHandler = (
  value: any,
  userSave: Save,
  resourceField: SaveKeys.RESOURCES | SaveKeys.IRESOURCES = SaveKeys.RESOURCES
) => {
  if (value) {
    const resources: Resources = value;
    const savedResources: JsonObject = updateResources(
      resources,
      userSave[resourceField] || {}
    );
    userSave[resourceField] = savedResources;
  }
};
