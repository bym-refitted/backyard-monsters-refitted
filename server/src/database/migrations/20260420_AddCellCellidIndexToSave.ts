import { Migration } from "@mikro-orm/migrations";

export class Migration20260420_AddCellCellidIndexToSave extends Migration {
  override isTransactional(): boolean {
    return false;
  }

  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS save_cell_cellid_idx
      ON bym.save (cell_cellid)
    `);
  }
}
