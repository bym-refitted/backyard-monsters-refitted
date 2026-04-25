import { Migration } from "@mikro-orm/migrations";

export class Migration20260423_RenameInfernoMaproom extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE inferno_maproom RENAME TO maproom_inferno;
    `);
  }
}
