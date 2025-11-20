import { Migration } from "@mikro-orm/migrations";

/**
 * Ensure that all user baseids (derived from basesaveid) start at 1000.
 * This prevents collisions with reserved client bases (IDs 1–1000).
 *
 * This should automatically run when executing the command: `npm run db:init`
 * It will create the schema if it does not exist and apply this migration.
 */
export class SetBaseSaveIDSeq extends Migration {
  async up(): Promise<void> {
    this.addSql(
      'ALTER SEQUENCE "bym"."save_basesaveid_seq" RESTART WITH 1000;'
    );
  }
}
