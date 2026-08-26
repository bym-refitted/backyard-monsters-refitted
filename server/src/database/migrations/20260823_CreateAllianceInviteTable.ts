import { Migration } from "@mikro-orm/migrations";

export class Migration20260823_CreateAllianceInviteTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.alliance_invite (
        id SERIAL PRIMARY KEY,
        alliance_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        type VARCHAR(10) NOT NULL,
        status VARCHAR(10) NOT NULL DEFAULT 'pending',
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_invite_alliance_id_status_index
      ON bym.alliance_invite (alliance_id, status)
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_invite_user_id_status_index
      ON bym.alliance_invite (user_id, status)
    `);

    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS alliance_invite_pending_unique
      ON bym.alliance_invite (alliance_id, user_id)
      WHERE status = 'pending'
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_invite
      ADD CONSTRAINT alliance_invite_type_check
      CHECK (type IN ('invite', 'request'))
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_invite
      ADD CONSTRAINT alliance_invite_status_check
      CHECK (status IN ('pending', 'accepted', 'declined'))
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_invite
      ADD CONSTRAINT fk_alliance_invite_alliance
      FOREIGN KEY (alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_invite
      ADD CONSTRAINT fk_alliance_invite_user
      FOREIGN KEY (user_id) REFERENCES bym."user"(userid) ON DELETE CASCADE
    `);
  }
}
