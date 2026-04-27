import { Migration } from "@mikro-orm/migrations";

/**
 * Makes mapversion non-nullable with a default of 1 (MR1).
 * - Backfills any existing NULL values to 1 (players who recycled their map room).
 * - Alters the column to NOT NULL DEFAULT 1 so it can never be null again.
 */
export class MakeMapversionNonNullable extends Migration {
  async up(): Promise<void> {
    this.addSql(`UPDATE "bym"."save" SET "mapversion" = 1 WHERE "mapversion" IS NULL;`);
    this.addSql(`ALTER TABLE "bym"."save" ALTER COLUMN "mapversion" SET NOT NULL;`);
    this.addSql(`ALTER TABLE "bym"."save" ALTER COLUMN "mapversion" SET DEFAULT 1;`);
  }
}
