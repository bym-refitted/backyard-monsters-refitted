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
  const resourceDataKey = ctx.request.body[SaveKeys.RESOURCES];
  const resourceData: Resources | undefined = JSON.parse(resourceDataKey);

  if (resourceData) {
    const clientResources: Resources = resourceData;

    if (isOutpost) {
      userSave.resources = updateResources(clientResources, userSave.resources);
    } else {
      save.resources = userSave.resources;
    }
  }
};
