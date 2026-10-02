import { Migration } from "@mikro-orm/migrations";

/**
 * Indexes lower(username) so player search can match a short name exactly
 * without a sequential scan.
 */
export class AddUsernameLowerIndex extends Migration {
  async up(): Promise<void> {
    await this.execute(`CREATE INDEX IF NOT EXISTS user_username_lower_index ON bym."user" (lower(username))`);
  }
}
