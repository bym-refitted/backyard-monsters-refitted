import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { DeleteMessagesSchema } from "../../schemas/AllianceSchemas.js";
import { deleteInviteMessages } from "../../services/alliance/allianceInvites.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Clears the rows a player checked in their Invites tab. Ids outside their own
 * inbox simply match nothing, so a tampered list deletes no one else's mail.
 *
 * @param {Context} ctx - Koa context.
 */
export const deleteMessages: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { invite_ids } = DeleteMessagesSchema.parse(ctx.request.body);

  const deleted = await deleteInviteMessages(user, invite_ids);

  ctx.status = Status.OK;
  ctx.body = { error: 0, deleted };
};
