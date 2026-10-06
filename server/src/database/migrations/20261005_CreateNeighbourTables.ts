import { Migration } from "@mikro-orm/migrations";

/**
 * Creates the two tables behind mutual Map Room 1 neighbours.
 *
 * bym.neighbour_attack is the single record of how often one player has
 * attacked another, backfilled from attack_logs.
 *
 * bym.neighbour_link holds one row per pair of players who are on each other's
 * map. It carries over every existing MR1 neighbour, in whichever direction it
 * was listed, along with any pair who attacked each other in the last two
 * weeks. That second part reads neighbour_attack, so the order here matters.
 */
export class CreateNeighbourTables extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.neighbour_attack (
        id             SERIAL PRIMARY KEY,
        type           VARCHAR(10) NOT NULL,
        attacker_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        defender_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        attacks        INTEGER NOT NULL DEFAULT 0,
        attacks_today  INTEGER NOT NULL DEFAULT 0,
        last_attack_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        CONSTRAINT neighbour_attack_type_check CHECK (type IN ('main', 'inferno')),
        CONSTRAINT neighbour_attack_not_self_check CHECK (attacker_id <> defender_id)
      )
    `);

    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS neighbour_attack_type_attacker_id_defender_id_unique
      ON bym.neighbour_attack (type, attacker_id, defender_id)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS neighbour_attack_type_defender_id_last_attack_at_index
      ON bym.neighbour_attack (type, defender_id, last_attack_at)
    `);

    await this.execute(`
      INSERT INTO bym.neighbour_attack (type, attacker_id, defender_id, attacks, attacks_today, last_attack_at)
      SELECT
        'main',
        log.attacker_userid,
        log.defender_userid,
        COUNT(*),
        COUNT(*) FILTER (WHERE log.attacktime >= CURRENT_DATE),
        MAX(log.attacktime)
      FROM bym.attack_logs log
      JOIN bym.save attacker ON attacker.userid = log.attacker_userid AND attacker.type = 'main' AND attacker.mapversion = 1
      JOIN bym.save defender ON defender.userid = log.defender_userid AND defender.type = 'main' AND defender.mapversion = 1
      WHERE log.type = 'main' AND log.attacker_userid <> log.defender_userid
      GROUP BY log.attacker_userid, log.defender_userid
      ON CONFLICT DO NOTHING
    `);

    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.neighbour_link (
        id           SERIAL PRIMARY KEY,
        type         VARCHAR(10) NOT NULL,
        user_a_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        user_b_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        CONSTRAINT neighbour_link_type_check CHECK (type IN ('main', 'inferno')),
        CONSTRAINT neighbour_link_order_check CHECK (user_a_id < user_b_id)
      )
    `);

    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS neighbour_link_type_user_a_id_user_b_id_unique
      ON bym.neighbour_link (type, user_a_id, user_b_id)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS neighbour_link_type_user_b_id_index
      ON bym.neighbour_link (type, user_b_id)
    `);

    await this.execute(`
      INSERT INTO bym.neighbour_link (type, user_a_id, user_b_id)
      SELECT DISTINCT 'main', LEAST(pair.a, pair.b), GREATEST(pair.a, pair.b)
      FROM (
        SELECT maproom.userid AS a, (neighbour->>'userid')::int AS b
        FROM bym.maproom maproom
        CROSS JOIN LATERAL jsonb_array_elements(maproom.neighbors) neighbour
        UNION ALL
        SELECT attacker_id, defender_id
        FROM bym.neighbour_attack
        WHERE type = 'main' AND last_attack_at >= NOW() - INTERVAL '14 days'
      ) pair
      JOIN bym.save a ON a.userid = pair.a AND a.type = 'main' AND a.mapversion = 1
      JOIN bym.save b ON b.userid = pair.b AND b.type = 'main' AND b.mapversion = 1
      WHERE pair.a <> pair.b
      ON CONFLICT DO NOTHING
    `);
  }
}
