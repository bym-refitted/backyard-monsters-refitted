import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { getInviteMessages } from "../../services/alliance/allianceInvites.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the authenticated player's Invites tab. One inbox carries both
 * directions: invites waiting on them, requests waiting on them as a leader, and
 * the outcomes of whatever they sent.
 *
 * @param {Context} ctx - Koa context.
 */
export const getMessages: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const messages = await getInviteMessages(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0, messages };
};
