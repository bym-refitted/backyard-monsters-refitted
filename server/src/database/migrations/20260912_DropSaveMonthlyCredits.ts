import { Migration } from "@mikro-orm/migrations";

/**
 * Drops save.monthly_credits.
 */
export class DropSaveMonthlyCredits extends Migration {
  async up(): Promise<void> {
    await this.execute(`ALTER TABLE bym.save DROP COLUMN IF EXISTS monthly_credits`);
  }
}
