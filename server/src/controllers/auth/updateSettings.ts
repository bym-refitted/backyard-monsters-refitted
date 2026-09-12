import type { KoaController } from "../../utils/KoaController.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { Status } from "../../enums/StatusCodes.js";
import { UpdateSettingsSchema } from "../../schemas/AuthSchemas.js";

/**
 * Controller to update the authenticated user's account settings.
 *
 * Callers send the whole settings block and it is echoed back, so the caller can render
 * the resulting state without a second request. Clients that never call this - the Android
 * and raw builds - are unaffected: the column defaults to false, and every guard reads it
 * from the account rather than from the request.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const updateSettings: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { shinyLocked } = UpdateSettingsSchema.parse(ctx.request.body);

  user.shiny_locked = shinyLocked;
  await postgres.em.flush();

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    settings: { shinyLocked: user.shiny_locked },
  };
};
