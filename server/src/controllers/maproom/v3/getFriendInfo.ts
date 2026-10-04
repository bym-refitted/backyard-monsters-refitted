import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../database/models/user.model.js";
import { getFriendYards } from "../../../services/maproom/v3/getFriendYards.js";
import { postgres } from "../../../server.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Lists the caller's friends who are in Map Room 3, for the Relocate Yard popup.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const getFriendInfo: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  await postgres.em.populate(user, ["save"]);

  const friends = await getFriendYards(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0, friends };
};
