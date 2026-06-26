import { Migration } from "@mikro-orm/migrations";

export class Migration20260626_CreateAllianceTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.alliance (
        id SERIAL PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        image INTEGER NOT NULL DEFAULT 1,
        description VARCHAR(255) NOT NULL DEFAULT '',
        leader_userid INTEGER NOT NULL,
        member_count INTEGER NOT NULL DEFAULT 0,
        empire_points BIGINT NOT NULL DEFAULT 0,
        level INTEGER NOT NULL DEFAULT 1,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);

    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS alliance_name_lower_idx ON bym.alliance (LOWER(name))
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_leader_userid_idx ON bym.alliance (leader_userid)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS empire_points_idx ON bym.alliance (empire_points DESC)
    `);

    await this.execute(`
      ALTER TABLE bym."user"
      ADD COLUMN IF NOT EXISTS alliance_id INTEGER,
      ADD COLUMN IF NOT EXISTS alliance_role VARCHAR(10)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS user_alliance_id_idx ON bym."user" (alliance_id)
    `);
  }
}
