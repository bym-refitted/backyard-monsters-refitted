import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.gift, the mystery sacks friends send each other.
 */
export class CreateGiftTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.gift (
        id              SERIAL PRIMARY KEY,
        sender_id       INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        recipient_id    INTEGER NOT NULL REFERENCES bym."user"(userid) ON DELETE CASCADE,
        created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
        claimed_at      TIMESTAMP,
        acknowledged_at TIMESTAMP,
        CONSTRAINT gift_not_self_check CHECK (sender_id <> recipient_id)
      )
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS gift_recipient_id_claimed_at_index
      ON bym.gift (recipient_id, claimed_at)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS gift_sender_id_acknowledged_at_index
      ON bym.gift (sender_id, acknowledged_at)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS gift_sender_id_recipient_id_created_at_index
      ON bym.gift (sender_id, recipient_id, created_at)
    `);
  }
}
