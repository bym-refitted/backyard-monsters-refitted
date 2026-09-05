import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.alliance_relationship, and gives alliance_message somewhere to
 * record which alliance a relationship shout was about.
 */
export class CreateAllianceRelationshipTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.alliance_relationship (
        alliance_id        INTEGER NOT NULL,
        target_alliance_id INTEGER NOT NULL,
        relationship       SMALLINT NOT NULL,
        updated_at         TIMESTAMP NOT NULL DEFAULT NOW(),
        PRIMARY KEY (alliance_id, target_alliance_id)
      )
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_relationship
      ADD CONSTRAINT alliance_relationship_value_check
      CHECK (relationship IN (-1, 0, 1))
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_relationship
      ADD CONSTRAINT alliance_relationship_not_self_check
      CHECK (alliance_id <> target_alliance_id)
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_relationship
      ADD CONSTRAINT alliance_relationship_alliance_id_foreign
      FOREIGN KEY (alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_relationship
      ADD CONSTRAINT alliance_relationship_target_alliance_id_foreign
      FOREIGN KEY (target_alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_relationship_target_alliance_id_index
      ON bym.alliance_relationship (target_alliance_id)
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_message
      ADD COLUMN IF NOT EXISTS target_alliance_id INTEGER
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_message
      ADD CONSTRAINT alliance_message_target_alliance_id_foreign
      FOREIGN KEY (target_alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);

    await this.execute(`
      CREATE INDEX IF NOT EXISTS alliance_message_target_alliance_id_index
      ON bym.alliance_message (target_alliance_id)
    `);
  }
}
