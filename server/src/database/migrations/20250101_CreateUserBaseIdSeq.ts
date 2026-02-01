import { Migration } from "@mikro-orm/migrations";

/**
 * Create a dedicated sequence for user-owned baseids starting at 1000.
 * This ensures new user bases are low-numbered and avoids collisions
 * with reserved client base IDs (1–1000).
 *
 * Tribes/outposts can continue using generateBaseId (24-bit hash) independently.
 */
export class CreateUserBaseIdSeq extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE SEQUENCE IF NOT EXISTS "bym"."user_baseid_seq"
      START 1000
      INCREMENT 1
      OWNED BY NONE;
    `);
  }
}
