import { BigIntType } from "@mikro-orm/core";
import { Entity, OneToOne, Property } from "@mikro-orm/decorators/es";

import { Alliance } from "./alliance.model.js";

/**
 * The bym.alliance_stats view: an alliance's standing, derived from its members.
 *
 * Nothing is stored on the alliance row, because these totals move whenever any member
 * builds, upgrades or is raided - none of which is an alliance event. A cached column
 * could only be refreshed on joins and leaves, the rare half of what changes it, so it
 * would drift from the day it was written.
 *
 * The totals are gathered in an inner query so the ranks can order by the alias rather
 * than repeat the sum: a window function cannot see a select alias from its own level.
 *
 * save_basesaveid already points at a member's main yard, but the type filter stays -
 * nothing enforces that invariant, and an outpost slipping in would inflate every total.
 */

const ALLIANCE_STATS_VIEW = `
  SELECT
    alliance_id,
    member_count,
    empire_points,
    avg_level,
    rank() over (PARTITION BY world_id    ORDER BY empire_points DESC)::int AS world_rank,
    rank() over (PARTITION BY map_version ORDER BY empire_points DESC)::int AS global_rank
  FROM (
    SELECT
      a.id AS alliance_id,
      a.world_id,
      a.map_version,
      count(u.userid)::int AS member_count,
      coalesce(sum(s.points::numeric + s.basevalue::numeric), 0)::bigint AS empire_points,
      coalesce(round(avg(s.level)), 0)::int AS avg_level
    FROM bym.alliance a
    LEFT JOIN bym."user" u ON u.alliance_id = a.id
    LEFT JOIN bym.save s ON u.save_basesaveid = s.basesaveid AND s.type = 'main'
    GROUP BY a.id, a.world_id, a.map_version
  ) totals
`;

@Entity({ tableName: "alliance_stats", view: true, expression: ALLIANCE_STATS_VIEW })
export class AllianceStats {
  @OneToOne({ entity: () => Alliance, primary: true, fieldName: "alliance_id", owner: true })
  alliance!: Alliance;

  @Property({ type: "number" })
  member_count!: number;

  @Property({ type: new BigIntType("number") })
  empire_points!: number;

  @Property({ type: "number" })
  avg_level!: number;

  @Property({ type: "number" })
  world_rank!: number;

  @Property({ type: "number" })
  global_rank!: number;
}
