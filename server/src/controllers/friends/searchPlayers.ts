import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { SearchPlayersSchema } from "../../schemas/FriendSchemas.js";
import { searchPlayers as findPlayers } from "../../services/friends/friendList.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Searches players by name for the launcher's Find Players tab.
 *
 * A term below the minimum length returns no results instead of an error, since
 * the launcher searches as the player types.
 *
 * @param {Context} ctx - Koa context.
 */
export const searchPlayers: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const parsed = SearchPlayersSchema.safeParse(ctx.query);

  const players = parsed.success ? await findPlayers(user, parsed.data.search) : [];

  ctx.status = Status.OK;
  ctx.body = { error: 0, players };
};
