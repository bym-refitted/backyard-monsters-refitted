import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";

/**
 * The bym.neighbour_candidate view: every Map Room 1 main base with the number of
 * neighbours its owner has now, so a search can ask for players with room and get
 * the ones with the most room first, in one query.
 *
 * The count is not stored on the save because it moves whenever anyone on the
 * other side of a link gains or loses that link - a column would have to be
 * rewritten for both players on every change, and would drift the first time one
 * write was missed.
 *
 * A link holds the lower user id first, so a player can be on either side of it
 * and the count is the sum of both. The two subqueries are each answered from an
 * index on neighbour_link, and only run for the saves a query's own filters keep.
 */

const NEIGHBOUR_CANDIDATE_VIEW = `
  SELECT
    s.userid,
    s.level,
    s.savetime,
    (
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'main' AND l.user_a_id = s.userid) +
      (SELECT count(*) FROM bym.neighbour_link l WHERE l.type = 'main' AND l.user_b_id = s.userid)
    )::int AS neighbours
  FROM bym.save s
  WHERE s.type = 'main' AND s.mapversion = 1
`;

@Entity({ tableName: "neighbour_candidate", view: true, expression: NEIGHBOUR_CANDIDATE_VIEW })
export class NeighbourCandidate {
  @PrimaryKey({ type: "number" })
  userid!: number;

  @Property({ type: "number" })
  level!: number;

  @Property({ type: "number" })
  savetime!: number;

  @Property({ type: "number" })
  neighbours!: number;
}
