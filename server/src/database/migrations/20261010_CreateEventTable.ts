import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.event, a player's score in one scheduled run of an event.
 */
export class CreateEventTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.event (
        id         SERIAL PRIMARY KEY,
        userid     INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        event      VARCHAR(255) NOT NULL,
        start_time INTEGER NOT NULL,
        score      INTEGER NOT NULL DEFAULT 0,
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        CONSTRAINT event_userid_event_start_time_unique UNIQUE (userid, event, start_time)
      )
    `);
  }
}
