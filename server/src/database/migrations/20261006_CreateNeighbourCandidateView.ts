import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.neighbour_candidate, which lists every Map Room 1 main base with
 * the number of neighbours its owner has now, for the neighbour search.
 */
export class CreateNeighbourCandidateView extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE OR REPLACE VIEW bym.neighbour_candidate AS
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
    `);
  }
}
