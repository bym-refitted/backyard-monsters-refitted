import type { KoaController } from "../../utils/KoaController.js";
import { User } from "../../models/user.model.js";
import { Status } from "../../enums/StatusCodes.js";
import { getUsernameCooldown } from "../../services/user/renameUser.js";

/**
 * Controller to return the authenticated user's account details.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getAccount: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const cooldown = getUsernameCooldown(user);

  const userDetails = {
    userId: user.userid,
    username: user.username,
    email: user.email,
    pic_square: user.pic_square,
    discord_verified: user.discord_verified,
    canChangeUsername: !cooldown,
    nextChangeAt: cooldown?.toISOString() ?? null,
  };

  ctx.status = Status.OK;
  ctx.body = { error: 0, ...userDetails };
};
