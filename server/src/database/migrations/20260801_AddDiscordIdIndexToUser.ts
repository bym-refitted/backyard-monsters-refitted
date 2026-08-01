import { Migration } from "@mikro-orm/migrations";

/**
 * Adds an index on user.discord_id.
 *
 * Every Discord bot lookup filters on this column - /register, ban, unban, user-info,
 * and the become-a-fan quest unlock - and without an index each one is a sequential
 * scan of the user table.
 */
export class AddDiscordIdIndexToUser extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE INDEX IF NOT EXISTS "user_discord_id_index"
        ON "bym"."user" ("discord_id");
    `);
  }
}
