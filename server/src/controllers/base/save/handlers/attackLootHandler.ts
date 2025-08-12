import { SaveKeys } from "../../../../enums/SaveKeys";
import { FieldData, Save } from "../../../../models/save.model";
import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";

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
