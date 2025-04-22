import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";
import { Save } from "../../../../models/save.model";
import { SaveKeys } from "../../../../enums/SaveKeys";

export const resourcesHandler = (
  save: Save,
  resourceVal: Resources | string | undefined,
  resourceKey: SaveKeys.RESOURCES | SaveKeys.IRESOURCES = SaveKeys.RESOURCES
) => {
  let resourceData: Resources | null = null;

  if (resourceVal) {
    try {
      resourceData = JSON.parse(resourceVal as string);
    } catch {
      resourceData = resourceVal as Resources;
    }
  }

  if (resourceData)
    save[resourceKey] = updateResources(resourceData, save[resourceKey]);
};
