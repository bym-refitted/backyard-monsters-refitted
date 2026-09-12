import { Migration } from "@mikro-orm/migrations";

export class IndexCleanup extends Migration {
  async up(): Promise<void> {
    this.addSql(`CREATE INDEX IF NOT EXISTS "save_userid_type_index" ON "bym"."save" ("userid", "type");`);

    this.addSql(`DROP INDEX IF EXISTS "bym"."save_userid_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."save_saveuserid_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."user_email_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."thread_threadid_index";`);

    this.addSql(`DROP INDEX IF EXISTS "bym"."save_main_savetime_index";`);

    this.addSql(`DROP INDEX IF EXISTS "bym"."message_userid_created_at_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."message_targetid_created_at_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."thread_truce_id_idx";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."thread_truce_id_index";`);
    this.addSql(`DROP INDEX IF EXISTS "bym"."idx_user_blocked_users";`);
  }
}
