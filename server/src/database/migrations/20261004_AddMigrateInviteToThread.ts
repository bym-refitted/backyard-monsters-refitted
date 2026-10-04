import { Migration } from "@mikro-orm/migrations";

/**
 * Adds the invitation state to bym.thread, for inviting a friend to move onto an outpost.
 */
export class AddMigrateInviteToThread extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      ALTER TABLE bym.thread
        ADD COLUMN IF NOT EXISTS migrate_baseid VARCHAR(255),
        ADD COLUMN IF NOT EXISTS migratestate   VARCHAR(255)
    `);
  }
}
