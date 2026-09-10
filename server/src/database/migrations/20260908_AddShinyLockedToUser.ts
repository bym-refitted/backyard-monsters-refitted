import { Migration } from "@mikro-orm/migrations";

/**
 * Adds user.shiny_locked to drive no-shiny mode.
 *
 * The flag only masks shiny on the way out and refuses it on the way in. It never
 * writes save.credits, so existing balances are correct as they stand and no backfill
 * is needed beyond defaulting every account to unlocked.
 */
export class AddShinyLockedToUser extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."user"
        ADD COLUMN IF NOT EXISTS "shiny_locked" boolean NOT NULL DEFAULT false;
    `);
  }
}
