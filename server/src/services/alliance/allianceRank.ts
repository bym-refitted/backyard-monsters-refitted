import { raw } from "@mikro-orm/postgresql";

import { AllianceFilter } from "../../enums/AllianceFilter.js";
import { Alliance } from "../../models/alliance.model.js";
import { postgres } from "../../server.js";

export type AllianceRanks = Promise<Map<number, number>>;

/**
 * Looks up alliance standings by empire points, strongest first. Ties share a
 * rank, so two alliances level on points are both 4th and the next is 6th.
 *
 * scope decides the population an alliance is ranked against, matching whichever
 * Browse filter the player is on: WORLD ranks only against alliances sharing its
 * world, GLOBAL against every alliance on its Map Room version. Neither ranks
 * across versions, since no alliance competes with the other side.
 *
 * @param {number[]} allianceIds - The alliances to look up.
 * @param {AllianceFilter} scope - The population to rank against.
 * @returns {AllianceRanks} Rank by alliance id; empty when no ids are given.
 */
export const getAllianceRanks = async (allianceIds: number[], scope: AllianceFilter): AllianceRanks => {
  if (allianceIds.length === 0) return new Map();

  const clause = scope === AllianceFilter.WORLD ? "partition by world_id" : "partition by map_version";

  const ranked = postgres.em
    .createQueryBuilder(Alliance, "a")
    .select(["id", raw(`rank() over (${clause} order by empire_points desc) as rank`)]);

  const standings = await postgres.em
    .createQueryBuilder(Alliance)
    .with("ranked", ranked)
    .from("ranked", "r")
    .select(["id", raw("rank")])
    .where({ id: { $in: allianceIds } })
    .execute<{ id: number; rank: string }[]>();

  return new Map(standings.map((standing) => [standing.id, Number(standing.rank)]));
};
