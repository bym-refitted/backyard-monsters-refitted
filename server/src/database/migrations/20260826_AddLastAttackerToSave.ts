import { Migration } from "@mikro-orm/migrations";

/**
 * Adds save.lastattackername so the alliance Members tab can read a base's most
 * recent attacker directly, rather than aggregating it out of attack_logs on every
 * read.
 */
export class AddLastAttackerToSave extends Migration {
  async up(): Promise<void> {
    this.addSql(`ALTER TABLE "bym"."save" ADD COLUMN IF NOT EXISTS "lastattackername" varchar(255) NULL;`);
  }
}
