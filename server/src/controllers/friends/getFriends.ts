import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { getFriendList } from "../../services/friends/friendList.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the launcher/website friends page: accepted friends, incoming requests and
 * outgoing requests.
 *
 * @param {Context} ctx - Koa context.
 */
export const getFriends: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  const list = await getFriendList(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0, ...list };
};
