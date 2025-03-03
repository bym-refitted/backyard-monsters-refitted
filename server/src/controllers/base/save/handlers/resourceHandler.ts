import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";
import { Save } from "../../../../models/save.model";
import { SaveKeys } from "../../../../enums/SaveKeys";

export const resourcesHandler = (
  save: Save,
  resourceVal: string | undefined,
  resourceKey: SaveKeys.RESOURCES | SaveKeys.IRESOURCES = SaveKeys.RESOURCES
) => {
  let resourceData: Resources | null = null;
  
  if (resourceVal) resourceData = JSON.parse(resourceVal);

  if (resourceData) 
    save[resourceKey] = updateResources(resourceData, save[resourceKey]);
};
