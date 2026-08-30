import { MAX_ALLIANCE_MEMBERS } from "../../config/AllianceConfig.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { getUserAlliance } from "../../services/alliance/allianceAccess.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the authenticated user's alliance for the My Alliance tab, or
 * `alliance: null` when they are unaffiliated. Rank is the alliance's standing
 * within its own world by empire points.
 *
 * @param {Context} ctx - Koa context.
 */
export const myAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await getUserAlliance(user, { withStats: true });

  if (!alliance) {
    ctx.status = Status.OK;
    ctx.body = { error: 0, alliance: null };
    return;
  }

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    alliance: {
      alliance_id: alliance.id,
      name: alliance.name,
      image: alliance.image,
      description: alliance.description,
      rank: alliance.stats?.world_rank,
      avg_level: alliance.stats?.avg_level,
      leader_name: alliance.leader_name,
      number_of_members: alliance.stats?.member_count,
      max_members: MAX_ALLIANCE_MEMBERS,
    },
  };
};
