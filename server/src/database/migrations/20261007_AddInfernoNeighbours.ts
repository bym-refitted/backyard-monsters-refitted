import { Migration } from "@mikro-orm/migrations";

/**
 * Brings the Inferno map onto the shared neighbour tables that Map Room 1 uses.
 *
 * - Indexes Inferno bases by level and how recently they were played, for the
 *   neighbour search.
 * - Rebuilds bym.neighbour_candidate to cover both maps, told apart by a type
 *   column. The view is dropped first because the new column goes in front.
 * - Backfills Inferno attack history from attack_logs, and Inferno neighbours
 *   from every cached list in maproom_inferno, in whichever direction a pair was
 *   listed, along with any pair who attacked each other in the last two weeks.
 * - Refreshes the planner's statistics. Without them the first searches after a
 *   bulk load pick the wrong index on neighbour_link and take seconds each.
 */
export class AddInfernoNeighbours extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX IF NOT EXISTS save_inferno_level_savetime_index
      ON bym.save (level, savetime DESC) INCLUDE (userid)
      WHERE type = 'inferno'
    `);

    await this.execute(`DROP VIEW IF EXISTS bym.neighbour_candidate`);

    await this.execute(`
      CREATE VIEW bym.neighbour_candidate AS
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
    `);

    await this.execute(`
      INSERT INTO bym.neighbour_attack (type, attacker_id, defender_id, attacks, attacks_today, last_attack_at)
      SELECT
        'inferno',
        log.attacker_userid,
        log.defender_userid,
        COUNT(*),
        COUNT(*) FILTER (WHERE log.attacktime >= CURRENT_DATE),
        MAX(log.attacktime)
      FROM bym.attack_logs log
      JOIN bym.save attacker ON attacker.userid = log.attacker_userid AND attacker.type = 'inferno'
      JOIN bym.save defender ON defender.userid = log.defender_userid AND defender.type = 'inferno'
      WHERE log.type = 'inferno' AND log.attacker_userid <> log.defender_userid
      GROUP BY log.attacker_userid, log.defender_userid
      ON CONFLICT DO NOTHING
    `);

    await this.execute(`
      INSERT INTO bym.neighbour_link (type, user_a_id, user_b_id)
      SELECT DISTINCT 'inferno', LEAST(pair.a, pair.b), GREATEST(pair.a, pair.b)
      FROM (
        SELECT maproom.userid AS a, (neighbour->>'userid')::int AS b
        FROM bym.maproom_inferno maproom
        CROSS JOIN LATERAL jsonb_array_elements(maproom.neighbors) neighbour
        UNION ALL
        SELECT attacker_id, defender_id
        FROM bym.neighbour_attack
        WHERE type = 'inferno' AND last_attack_at >= NOW() - INTERVAL '14 days'
      ) pair
      JOIN bym.save a ON a.userid = pair.a AND a.type = 'inferno'
      JOIN bym.save b ON b.userid = pair.b AND b.type = 'inferno'
      WHERE pair.a <> pair.b
      ON CONFLICT DO NOTHING
    `);

    await this.execute(`ANALYZE bym.neighbour_link`);
    await this.execute(`ANALYZE bym.neighbour_attack`);
  }
}
