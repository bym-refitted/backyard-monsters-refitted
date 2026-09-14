import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.api_consumer, the API keys issued to external apps for the bulk
 * map endpoints (/worldmapv2/terrain and /worldmapv2/snapshot).
 */
export class CreateApiConsumerTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.api_consumer (
        id            SERIAL PRIMARY KEY,
        name          VARCHAR(255) NOT NULL,
        key_prefix    VARCHAR(32)  NOT NULL,
        key_hash      VARCHAR(64)  NOT NULL UNIQUE,
        created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
        last_used_at  TIMESTAMPTZ,
        revoked_at    TIMESTAMPTZ
      )
    `);
  }
}
