import type { KoaController } from "../../utils/KoaController.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { Status } from "../../enums/StatusCodes.js";
import { UpdateRadioAlertsSchema } from "../../schemas/AuthSchemas.js";
import { radioAlertSettings } from "../../services/user/radioAlertSettings.js";

/**
 * Controller to save the player's Radio Tower alert settings.
 *
 * Called by the Radio Tower popup on save, and with both alerts off when the tower is
 * recycled. Alerts are sent to the account email. The saved settings are echoed back so
 * the client only adopts them once the server has confirmed.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const updateRadioAlerts: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { attackAlerts, newsAlerts } = UpdateRadioAlertsSchema.parse(ctx.request.body);

  user.radio_attack_alerts = attackAlerts;
  user.radio_news_alerts = newsAlerts;
  await postgres.em.flush();

  const radio = radioAlertSettings(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0, radio };
};
