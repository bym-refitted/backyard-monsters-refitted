import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../database/models/user.model.js";
import { MigrateToFriendSchema } from "../../../schemas/MigrateToFriendSchema.js";
import { rejectMigrateInvite } from "../../../services/maproom/v2/migrateInvite.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Turns down a friend's invitation to move onto one of their outposts.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const rejectMigrateToFriend: KoaController = async (ctx) => {
  const { baseid, threadid } = MigrateToFriendSchema.parse(ctx.request.body);

  const user: User = ctx.authUser;

  await rejectMigrateInvite(user.userid, baseid, threadid);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
