import type { KoaController } from "../../utils/KoaController.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { Status } from "../../enums/StatusCodes.js";
import { UnsubscribeSchema } from "../../schemas/RadioSchemas.js";
import { isValidUnsubscribeToken } from "../../services/radio/unsubscribeLink.js";

/** Relative, as this page is served by the same server as public/assets. */
const LOGO_URL = "/assets/bym-refitted-assets/refitted-logo.png";

/**
 * Builds the small confirmation page shown after following an unsubscribe link.
 *
 * @param {string} heading - The page heading.
 * @param {string} message - The line under the heading.
 * @returns {string} The page HTML.
 */
const page = (heading: string, message: string): string => `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${heading} | BYM Refitted</title>
</head>
<body style="margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#1d2029;color:#d6d8de;font-family:Arial,Helvetica,sans-serif;text-align:center;">
  <main style="max-width:420px;padding:32px;">
    <img src="${LOGO_URL}" alt="Backyard Monsters Refitted" width="160" style="display:block;margin:0 auto 24px;">
    <h1 style="margin:0 0 12px;color:#fff;font-size:24px;">${heading}</h1>
    <p style="margin:0;line-height:1.5;">${message}</p>
  </main>
</body>
</html>`;

/**
 * Controller for the unsubscribe link in Radio Tower alert emails.
 *
 * Serves both the link a player clicks (GET) and the one-click unsubscribe that mail
 * providers send (POST, RFC 8058); both carry the user id and token in the query string.
 * Turns off every Radio Tower alert, so the player gets no email from us at all.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const unsubscribe: KoaController = async (ctx) => {
  const query = UnsubscribeSchema.safeParse(ctx.query);
  const isGenuine = query.success && isValidUnsubscribeToken(query.data.u, query.data.t);

  ctx.type = "html";

  if (!isGenuine) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = page("Link not recognised", "This unsubscribe link isn't valid. You can turn alerts off from your Radio Tower in game.");
    return;
  }

  await postgres.em.nativeUpdate(User, { userid: query.data.u }, { radio_attack_alerts: false, radio_news_alerts: false });

  ctx.status = Status.OK;
  ctx.body = page("You're unsubscribed", "You won't get any more alert emails. Turn them back on from your Radio Tower in game.");
};
