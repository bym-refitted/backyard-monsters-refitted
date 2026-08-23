import type { FilterQuery } from "@mikro-orm/core";

import { AllianceFilter } from "../../enums/AllianceFilter.js";
import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { SearchAlliancesSchema } from "../../schemas/AllianceSchemas.js";
import { getLeaderBaseIds } from "../../services/alliance/allianceLeaders.js";
import { getAllianceRanks } from "../../services/alliance/allianceRank.js";
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

  const searchOptions = {
    limit: PAGE_SIZE,
    offset: page * PAGE_SIZE,
    orderBy: { empire_points: "DESC", id: "ASC" },
    fields: ["*", "member_count"],
  } as const;

  const [alliances, totalResults] = await postgres.em.findAndCount(Alliance, where, searchOptions);

  const allianceIds = alliances.map((alliance) => alliance.id);
  const leaderIds = alliances.map((alliance) => alliance.leader_userid);

  const filter = world ? AllianceFilter.WORLD : AllianceFilter.GLOBAL;

  const [ranks, leaders] = await Promise.all([
    getAllianceRanks(allianceIds, filter),
    getLeaderBaseIds(leaderIds),
  ]);

  const results = alliances.map((alliance) => ({
    alliance_id: alliance.id,
    name: alliance.name,
    image: alliance.image,
    members: alliance.member_count,
    leader_name: alliance.leader_name,
    leader_baseid: leaders.get(alliance.leader_userid),
    rank: ranks.get(alliance.id),
    relationship: 0,
    ep: 1,
  }));

  ctx.status = Status.OK;
  ctx.body = { error: 0, alliances: results, pageSize: PAGE_SIZE, totalResults };
};
