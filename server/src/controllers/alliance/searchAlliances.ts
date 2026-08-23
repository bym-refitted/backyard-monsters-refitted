import { QueryFlag, type FilterQuery } from "@mikro-orm/core";

import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { SearchAlliancesSchema } from "../../schemas/AllianceSchemas.js";
import type { KoaController } from "../../utils/KoaController.js";
import { allianceNoWorldErr } from "../../errors/errors.js";

const PAGE_SIZE = 10;

/**
 * Search alliances for the Browse tab - a leaderboard the client
 * paginates 10 rows at a time.
 *
 * @param {Context} ctx - Koa context.
 */
export const searchAlliances: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { search, page, world } = SearchAlliancesSchema.parse(ctx.request.body);

  const where: FilterQuery<Alliance> = {};

  if (search) where.name = { $ilike: `%${search}%` };

  if (world) {
    await postgres.em.populate(user, ["save"]);
    const worldid = user.save?.worldid;

    if (!worldid) throw allianceNoWorldErr();

    where.world_id = worldid;
  }

  const [alliances, totalResults] = await postgres.em.findAndCount(Alliance, where, {
    limit: PAGE_SIZE,
    offset: page * PAGE_SIZE,
    orderBy: { empire_points: "DESC", id: "ASC" },
    flags: [QueryFlag.INCLUDE_LAZY_FORMULAS],
  });

  const rows = alliances.map((alliance) => ({
    alliance_id: alliance.id,
    name: alliance.name,
    image: alliance.image,
    members: alliance.member_count,
    leader_name: alliance.leader_name,
    relationship: 0,
    rank: 1,
    ep: 1,
  }));

  ctx.status = Status.OK;
  ctx.body = { error: 0, alliances: rows, pageSize: PAGE_SIZE, totalResults };
};
