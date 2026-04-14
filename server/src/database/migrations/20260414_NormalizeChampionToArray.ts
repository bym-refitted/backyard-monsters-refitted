import { Migration } from "@mikro-orm/migrations";

/**
 * Normalize the champion column to a non-nullable JSON array with a default of '[]',
 * and strip the legacy 'log' field from any champion entries.
 *
 * MikroORM double-encodes JSON — arrays are stored as jsonb strings (e.g. "[{...}]"),
 * so jsonb_typeof returns 'string' for all rows. Steps:
 *   1. Convert SQL/JSON null rows to '[]'
 *   2. Unwrap double-encoded strings to proper jsonb arrays
 *   3. Strip legacy 'log' field (all rows are now proper arrays)
 *   4. Add NOT NULL + DEFAULT constraints
 */
export class NormalizeChampionToArray extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      UPDATE "bym"."save"
      SET "champion" = '[]'::jsonb
      WHERE "champion" IS NULL
         OR jsonb_typeof("champion") = 'null'
         OR (jsonb_typeof("champion") = 'string' AND "champion"#>>'{}' = 'null');

      UPDATE "bym"."save"
      SET "champion" = ("champion"#>>'{}')::jsonb
      WHERE jsonb_typeof("champion") = 'string';

      UPDATE "bym"."save"
      SET "champion" = (
        SELECT jsonb_agg(elem - 'log')
        FROM jsonb_array_elements("champion") elem
      )
      WHERE EXISTS (
        SELECT 1 FROM jsonb_array_elements("champion") e WHERE e ? 'log'
      );

      ALTER TABLE "bym"."save"
        ALTER COLUMN "champion" SET NOT NULL,
        ALTER COLUMN "champion" SET DEFAULT '[]';
    `);
  }
}
