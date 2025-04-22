import { FieldData, Save } from "../../../../models/save.model";
import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";

export const attackLootHandler = (value: any, userSave: Save) => {
  if (value) {
    const resources: Resources = value;
    const savedResources: FieldData = updateResources(
      resources,
      userSave.resources || {}
    );
    userSave.resources = savedResources;
  }
};
