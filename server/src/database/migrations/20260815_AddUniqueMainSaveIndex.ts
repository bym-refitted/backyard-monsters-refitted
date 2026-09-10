import { Migration } from "@mikro-orm/migrations";

/**
 * Enforces one main save per user.
 *
 * Partial so outposts, tribes and inferno saves are unaffected - a user is expected
 * to own many of those.
 */
export class AddUniqueMainSaveIndex extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE UNIQUE INDEX IF NOT EXISTS save_one_main_per_user
      ON bym.save (userid)
      WHERE type = 'main'
    `);
  }
}
