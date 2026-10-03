import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { getFriendList } from "../../services/friends/friendList.js";
import { getGiftCooldowns } from "../../services/gifts/gifts.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the launcher/website friends page: accepted friends, incoming requests and
 * outgoing requests.
 *
 * @param {Context} ctx - Koa context.
 */
export const getFriends: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  const friendList = await getFriendList(user);

  const friendIds = friendList.friends.map((friend) => friend.user_id);
  
  const cooldowns = await getGiftCooldowns(user.userid, friendIds);

  const friends = friendList.friends.map((friend) => ({
    ...friend,
    gift_ready_at: cooldowns.get(friend.user_id) ?? null,
  }));

  ctx.status = Status.OK;
  ctx.body = { error: 0, ...friendList, friends };
};
