import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";
import { Save } from "../../../../models/save.model";

export const resourcesHandler = (
  resourceVal: any,
  userSave: Save,
  save: Save,
  isOutpost?: boolean
) => {
  // Parse the resource data if it's a JSON string
  const resourceData: Resources | undefined = JSON.parse(resourceVal);

  if (resourceData) {
    const resources: Resources = resourceData;

    let saveResources = isOutpost ? userSave.resources : save.resources;

    const savedResources = updateResources(resources, saveResources);
    if (isOutpost) userSave.resources = savedResources;
    else save.resources = savedResources;
  }
};
