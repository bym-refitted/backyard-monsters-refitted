import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.alliance_message, the durable record behind alliance chat.
 */
export class Migration20260830_CreateAllianceMessageTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.alliance_message (
        id BIGSERIAL PRIMARY KEY,
        alliance_id INTEGER NOT NULL,
        user_id INTEGER,
        type VARCHAR(16) NOT NULL DEFAULT 'message',
        body TEXT NOT NULL DEFAULT '',
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_message_alliance_id_id_index
      ON bym.alliance_message (alliance_id, id DESC)
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_message
      ADD CONSTRAINT alliance_message_type_check
      CHECK (type IN ('message', 'joined', 'left', 'kicked', 'promoted', 'created', 'relationship'))
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_message
      ADD CONSTRAINT alliance_message_alliance_id_foreign
      FOREIGN KEY (alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_message
      ADD CONSTRAINT alliance_message_user_id_foreign
      FOREIGN KEY (user_id) REFERENCES bym."user"(userid) ON DELETE SET NULL
    `);
  }
}
