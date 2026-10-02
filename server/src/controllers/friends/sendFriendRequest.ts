import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { FriendTargetSchema } from "../../schemas/FriendSchemas.js";
import { sendFriendRequest as requestFriend } from "../../services/friends/friendships.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Sends a friend request. If the other player had already asked, this accepts
 * theirs instead, and the returned status says so.
 *
 * @param {Context} ctx - Koa context.
 */
export const sendFriendRequest: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = FriendTargetSchema.parse(ctx.request.body);

  const status = await requestFriend(user, userid);

  ctx.status = Status.OK;
  ctx.body = { error: 0, status };
};
