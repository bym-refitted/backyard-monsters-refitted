import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import type { NeighbourAttackType } from "./neighbourattack.model.js";

/**
 * The bym.neighbour_candidate view: every base a neighbour search can return,
 * with the number of neighbours its owner has now on that map. A search can ask
 * for players with room and get the ones with the most room first, in one query.
 *
 * It covers both maps that have neighbours, told apart by type: Map Room 1 main
 * bases, and Inferno bases.
 *
 * The count is not stored on the save because it moves whenever anyone on the
 * other side of a link gains or loses that link - a column would have to be
 * rewritten for both players on every change, and would drift the first time one
 * write was missed.
 *
 * A link holds the lower user id first, so a player can be on either side of it
 * and the count is the sum of both. The subqueries are each answered from an
 * index on neighbour_link, and only run for the saves a query's own filters keep.
 */

const NEIGHBOUR_CANDIDATE_VIEW = `
  SELECT
    'main'::varchar AS type,
    s.userid,
    s.level,
    s.savetime,
    (
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'main' AND l.user_a_id = s.userid) +
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'main' AND l.user_b_id = s.userid)
    )::int AS neighbours
  FROM bym.save s
  WHERE s.type = 'main' AND s.mapversion = 1
  UNION ALL
  SELECT
    'inferno'::varchar AS type,
    s.userid,
    s.level,
    s.savetime,
    (
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'inferno' AND l.user_a_id = s.userid) +
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'inferno' AND l.user_b_id = s.userid)
    )::int AS neighbours
  FROM bym.save s
  WHERE s.type = 'inferno'
`;

@Entity({ tableName: "neighbour_candidate", view: true, expression: NEIGHBOUR_CANDIDATE_VIEW })
export class NeighbourCandidate {
  @PrimaryKey({ type: "string" })
  type!: NeighbourAttackType;

  @PrimaryKey({ type: "number" })
  userid!: number;

  @Property({ type: "number" })
  level!: number;

  @Property({ type: "number" })
  savetime!: number;

  @Property({ type: "number" })
  neighbours!: number;
}
