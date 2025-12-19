import { Migration } from "@mikro-orm/migrations";

/**
 * Remove redundant damage protection tracking columns.
 * The system now uses only the 'protected' timestamp field instead of
 * separate tracking columns (mainProtectionTime, outpostProtectionTime,
 * initialProtectionOver, initialOutpostProtectionOver).
 */
export class DeleteProtectionCols extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."save"
      DROP COLUMN IF EXISTS "main_protection_time",
      DROP COLUMN IF EXISTS "outpost_protection_time",
      DROP COLUMN IF EXISTS "initial_protection_over",
      DROP COLUMN IF EXISTS "initial_outpost_protection_over";
    `);

    this.addSql(`
      ALTER TABLE "bym"."save"
      ALTER COLUMN "protected" SET DEFAULT 0;
    `);
  }
}
