import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { KoaController } from "../../utils/KoaController.js";

/**
 * Controller to handle the retrieval of Yard Planner slots/templates for the authenticated user.
 * 
 * @param {Context} ctx - The Koa context object, which includes the authenticated user.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getTemplates: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let save = user.save;

  await postgres.em.populate(user, ["save"]);
  const template = save.savetemplate;

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    ...template,
  };
};
