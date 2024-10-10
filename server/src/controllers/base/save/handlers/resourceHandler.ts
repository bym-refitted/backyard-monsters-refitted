import { Context } from "koa";
import { SaveKeys } from "../../../../enums/SaveKeys";
import {
  Resources,
  updateResources,
} from "../../../../services/base/updateResources";
import { Save } from "../../../../models/save.model";

export const resourcesHandler = (
  ctx: Context,
  userSave: Save,
  save: Save,
  isOutpost: boolean
) => {
  const resourceData: Resources = ctx.request.body[SaveKeys.RESOURCES];

  // Update resources with the delta sent from the client
  if (resourceData) {
    const resources: Resources = resourceData;

    let saveResources = isOutpost ? userSave.resources : save.resources;

    const savedResources = updateResources(resources, saveResources);
    if (isOutpost) userSave.resources = savedResources;
    else save.resources = savedResources;
  }
};