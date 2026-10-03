import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.base_update, the per base activity feed that carries friend help.
 */
export class CreateBaseUpdateTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.base_update (
        id           SERIAL PRIMARY KEY,
        baseid       VARCHAR(255) NOT NULL,
        sender_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        opcode       VARCHAR(255) NOT NULL,
        data         JSONB NOT NULL,
        created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
        delivered_at TIMESTAMP
      )
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS base_update_baseid_delivered_at_index
      ON bym.base_update (baseid, delivered_at)
    `);
  }
}
