import { Migration } from "@mikro-orm/migrations";

/**
 * Indexes main saves by how recently they were played, for the alliance Suggested
 * tab - which orders candidates newest-first and takes only the top handful.
 *
 * Partial on type = 'main' because that is the only base a player is suggested by,
 * and it keeps the index a fraction of the table's size. Without it the planner
 * cannot stop early and materialises every unaffiliated player before sorting.
 *
 * On a populated database build this with CREATE INDEX CONCURRENTLY by hand, outside
 * a transaction, to avoid holding a write lock on save.
 */
export class AddSavetimeIndexToSave extends Migration {
  async up(): Promise<void> {
    this.addSql(
      `CREATE INDEX IF NOT EXISTS "save_main_savetime_index" ON "bym"."save" ("savetime" DESC) WHERE "type" = 'main';`,
    );
  }
}
