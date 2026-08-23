import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { getUserAlliance } from "../../services/alliance/allianceAccess.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the authenticated user's alliance for the My Alliance tab, or
 * `alliance: null` when they are unaffiliated. `number_of_members` and
 * `leader_name` are cached columns on the alliance row; rank is the alliance's
 * position within its world by empire points.
 *
 * @param {Context} ctx - Koa context.
 */
export const myAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await getUserAlliance(user, { withMemberCount: true });

  if (!alliance) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, alliance: null };
    return;
  }

  const { world_id, empire_points } = alliance;

  const rank = await postgres.em.count(Alliance, { world_id, empire_points: { $gt: empire_points } });

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    alliance: {
      alliance_id: alliance.id,
      name: alliance.name,
      image: alliance.image,
      description: alliance.description,
      rank: rank + 1,
      avg_level: 1, // TODO: implement avg_level as a cached column on the alliance row
      leader_name: alliance.leader_name,
      number_of_members: alliance.member_count,
    },
  };
};
