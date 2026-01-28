import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";

interface RequestBody {
  slotid: number;
  name: string;
  data: Record<string, {}>;
}

/**
 * Controller to handle saving a Yard Planner slot/template for the authenticated user.
 * 
 * If a template with the same slot ID already exists, it will be overwritten. 
 * Otherwise, a new template will be added.
 * 
 * @param {Context} ctx - The Koa context object, which includes the authenticated user and request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const saveTemplate: KoaController = async (ctx) => {
  const requestBody = ctx.request.body as RequestBody;
  const user: User = ctx.authUser;
  let save = user.save;

  await postgres.em.populate(user, ["save"]);

  const existingSlotIndex = save.savetemplate.findIndex(
    (template) => template.slotid === requestBody.slotid
  );

  if (existingSlotIndex !== -1) {
    // Overwrite the existing layout
    save.savetemplate[existingSlotIndex] = { ...requestBody };
  } else {
    // Insert new layout if slotid doesn't exist
    save.savetemplate.push({ ...requestBody });
  }
  await postgres.em.persistAndFlush(save);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    ...save.savetemplate,
  };
};
