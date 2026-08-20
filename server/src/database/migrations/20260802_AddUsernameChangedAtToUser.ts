import { Migration } from "@mikro-orm/migrations";

/**
 * Adds user.username_changed_at to drive the rename cooldown.
 *
 * Null means the account has never been renamed, which the cooldown check treats as
 * immediately eligible. Existing accounts are backfilled as null for that reason.
 */
export class AddUsernameChangedAtToUser extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."user"
        ADD COLUMN IF NOT EXISTS "username_changed_at" timestamptz NULL;
    `);
  }
}
