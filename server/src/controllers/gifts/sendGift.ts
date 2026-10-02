import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { SendGiftSchema } from "../../schemas/GiftSchemas.js";
import { sendGift as giftFriend } from "../../services/gifts/gifts.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Sends a mystery sack to a friend, from the launcher or the website. It waits
 * on their base until they next load it.
 *
 * @param {Context} ctx - Koa context.
 */
export const sendGift: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = SendGiftSchema.parse(ctx.request.body);

  const gift = await giftFriend(user, userid);

  ctx.status = Status.OK;
  ctx.body = { error: 0, gift_id: gift.id };
};
