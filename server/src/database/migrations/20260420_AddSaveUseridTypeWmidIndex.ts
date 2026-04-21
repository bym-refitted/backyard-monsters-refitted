import { Migration } from "@mikro-orm/migrations";

export class Migration20260420_AddSaveUseridTypeWmidIndex extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX IF NOT EXISTS save_saveuserid_type_wmid_idx
      ON bym.save (saveuserid, type, wmid)
    `);
  }
}
