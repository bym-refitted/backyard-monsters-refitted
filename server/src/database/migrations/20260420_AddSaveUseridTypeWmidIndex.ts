import { Migration } from "@mikro-orm/migrations";

export class Migration20260420_AddSaveUseridTypeWmidIndex extends Migration {
  override isTransactional(): boolean {
    return false;
  }

  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS save_saveuserid_type_wmid_idx
      ON bym.save (saveuserid, type, wmid)
    `);
  }
}
