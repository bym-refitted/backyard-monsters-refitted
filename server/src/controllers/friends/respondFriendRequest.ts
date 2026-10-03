import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { RespondFriendRequestSchema } from "../../schemas/FriendSchemas.js";
import { answerFriendRequest } from "../../services/friends/friendships.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Accepts or declines an incoming friend request.
 *
 * @param {Context} ctx - Koa context.
 */
export const respondFriendRequest: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { request_id, accept } = RespondFriendRequestSchema.parse(ctx.request.body);

  await answerFriendRequest(user, request_id, accept);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
