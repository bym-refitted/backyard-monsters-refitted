import { User } from "../../database/models/user.model.js";
import { Status } from "../../enums/StatusCodes.js";
import { postgres } from "../../server.js";
import { openGiantPumpkin } from "../../services/events/halloween/halloween.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Opens the player's Giant Pumpkin on Halloween and gives them the Goodie Bag, once a year. A repeat call, or one
 * outside Halloween, grants nothing and says so, so the client skips the Goodie Bag.
 *
 * @param {Context} ctx - Koa context.
 */
export const openHalloweenPumpkin: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const reward = await openGiantPumpkin(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0, ...reward };
};
