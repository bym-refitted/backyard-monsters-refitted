import { Migration } from "@mikro-orm/migrations";

/**
 * Adds indexes that exist in production but were never created by a migration file,
 * meaning they would be missing on any database that wasn't manually patched.
 *
 * idx_user_blocked_users: GIN index on user.blocked_users (jsonb array).
 * Required for efficient containment queries (@>) when checking blocked user lists.
 * GIN indexes must be specified explicitly — MikroORM's createSchema does not infer
 * them from plain @Index decorators on json columns without the type: 'gin' option.
 */
export class AddBlockedUsersIndex extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE INDEX IF NOT EXISTS "idx_user_blocked_users"
        ON "bym"."user" USING gin ("blocked_users");
    `);
  }
}
