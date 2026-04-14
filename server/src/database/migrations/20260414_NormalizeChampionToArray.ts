import { Migration } from "@mikro-orm/migrations";

/**
 * Normalize the champion column to a non-nullable JSON array with a default of '[]'.
 *
 * Current DB state:
 *   - Players with champions: proper JSON array [{...}] — already correct, untouched
 *   - Players without champions: JSON null ('null') — converted to '[]'
 */
export class NormalizeChampionToArray extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      UPDATE "bym"."save"
      SET "champion" = '[]'::json
      WHERE "champion"::text = 'null';

      ALTER TABLE "bym"."save"
        ALTER COLUMN "champion" SET NOT NULL,
        ALTER COLUMN "champion" SET DEFAULT '[]';
    `);
  }
}
