import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../database/models/user.model.js";
import { acceptMigrateInvite } from "../../../services/maproom/v2/migrateInvite.js";
import { MigrateToFriendSchema } from "../../../schemas/MigrateToFriendSchema.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Accepts a friend's invitation to move onto one of their outposts.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const migrateToFriend: KoaController = async (ctx) => {
  const { baseid, threadid, shiny } = MigrateToFriendSchema.parse(ctx.request.body);

  const user: User = ctx.authUser;
  const outcome = await acceptMigrateInvite(user, baseid, threadid, Boolean(shiny));

  ctx.status = Status.OK;
  ctx.body = { error: 0, ...outcome };
};
