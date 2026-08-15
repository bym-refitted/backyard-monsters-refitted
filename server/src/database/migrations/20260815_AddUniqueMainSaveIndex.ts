import { Migration } from "@mikro-orm/migrations";

/**
 * Enforces one `type = 'main'` save per user.
 * 
 * Partial so outposts, tribes and inferno saves are unaffected - a user is expected
 * to own many of those.
 *
 * Built CONCURRENTLY so the live save table keeps accepting writes, which requires
 * this migration to run outside a transaction.
 */
export class AddUniqueMainSaveIndex extends Migration {
  isTransactional(): boolean {
    return false;
  }

  async up(): Promise<void> {
    await this.execute(`
      CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS save_one_main_per_user
      ON bym.save (userid)
      WHERE type = 'main'
    `);
  }
}
