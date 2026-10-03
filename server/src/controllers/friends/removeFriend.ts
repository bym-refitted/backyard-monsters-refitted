import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { FriendTargetSchema } from "../../schemas/FriendSchemas.js";
import { removeFriend as unfriend } from "../../services/friends/friendships.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Removes a friend, or cancels a request the player sent.
 *
 * @param {Context} ctx - Koa context.
 */
export const removeFriend: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = FriendTargetSchema.parse(ctx.request.body);

  await unfriend(user, userid);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
