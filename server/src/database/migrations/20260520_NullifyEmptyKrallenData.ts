import { Migration } from "@mikro-orm/migrations";

/**
 * Null out krallen rows that carry no real KOTH progress:
 *   1. Empty object {} — was the old model default, never meaningful.
 *   2. All-zero object — written by the client between the a42c1346 and 902e0907
 *      commits (May 5–17 2026) when KOTHHandler.exportData() started returning
 *      {tier:0, wins:0, loot:0, countdown:0, lastShownTier:0} instead of null
 *      for users with no KOTH progress.
 */
export class NullifyEmptyKrallenData extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      UPDATE "bym"."save"
      SET "krallen" = NULL
      WHERE "krallen" = '{}'::jsonb
         OR (
           "krallen" IS NOT NULL
           AND ("krallen"->>'wins')::numeric = 0
           AND ("krallen"->>'tier')::numeric = 0
           AND ("krallen"->>'loot')::numeric = 0
         );
    `);
  }
}
