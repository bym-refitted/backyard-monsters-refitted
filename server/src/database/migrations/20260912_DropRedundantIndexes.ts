import { Migration } from "@mikro-orm/migrations";

export class DropRedundantIndexes extends Migration {
  async up(): Promise<void> {
    this.addSql(`DROP INDEX IF EXISTS "bym"."save_saveuserid_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."user_email_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."thread_threadid_index";`);
  }
}
