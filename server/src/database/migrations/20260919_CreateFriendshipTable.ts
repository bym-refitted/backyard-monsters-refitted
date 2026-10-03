import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.friendship for the launcher friend system, and a trigram index on
 * user.username so player search can match any part of a name.
 */
export class CreateFriendshipTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.friendship (
        id SERIAL PRIMARY KEY,
        requester_id INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        recipient_id INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        status VARCHAR(10) NOT NULL DEFAULT 'pending',
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        responded_at TIMESTAMP,
        CONSTRAINT friendship_status_check CHECK (status IN ('pending', 'accepted')),
        CONSTRAINT friendship_not_self_check CHECK (requester_id <> recipient_id)
      )
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS friendship_requester_id_status_index
      ON bym.friendship (requester_id, status)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS friendship_recipient_id_status_index
      ON bym.friendship (recipient_id, status)
    `);

    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS friendship_pair_unique
      ON bym.friendship (LEAST(requester_id, recipient_id), GREATEST(requester_id, recipient_id))
    `);

    await this.execute(
      `CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public`,
    );

    await this.execute(`
      CREATE INDEX IF NOT EXISTS user_username_trgm_index
      ON bym."user" USING gin (username public.gin_trgm_ops)
    `);
  }
}
