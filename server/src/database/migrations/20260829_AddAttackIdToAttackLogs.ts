import { Migration } from "@mikro-orm/migrations";

/**
 * Adds attack_logs.attackid — the join key between an attack_logs row (created at
 * attack start in baseModeAttack / infernoModeAttack) and the battle report that
 * arrives later on the attacker's base-save request. save.attackid is a random
 * 1–99999 set immediately before createAttackLog, and the client echoes it back
 * as saveData.attackid on the final save.
 */
export class AddAttackIdToAttackLogs extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."attack_logs"
        ADD COLUMN IF NOT EXISTS "attackid" integer NULL;
    `);
    this.addSql(`
      CREATE INDEX IF NOT EXISTS "attack_logs_attackid_index"
        ON "bym"."attack_logs" ("attackid");
    `);
  }

  async down(): Promise<void> {
    this.addSql(`DROP INDEX IF EXISTS "bym"."attack_logs_attackid_index";`);
    this.addSql(`ALTER TABLE "bym"."attack_logs" DROP COLUMN IF EXISTS "attackid";`);
  }
}
