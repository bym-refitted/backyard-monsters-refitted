import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { ChangeInviteStatusSchema } from "../../schemas/AllianceSchemas.js";
import { answerInvite } from "../../services/alliance/allianceInvites.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Answers a pending invite or join request from the Invites tab. Accepting an
 * invite joins the player; accepting a request admits the player who asked.
 * Either way the row stays, flipping to an outcome notice for whoever opened it.
 *
 * @param {Context} ctx - Koa context.
 */
export const changeInviteStatus: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { invite_id, status } = ChangeInviteStatusSchema.parse(ctx.request.body);

  await answerInvite(user, invite_id, status);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
