import { Migration } from "@mikro-orm/migrations";

export class Migration20260420_AddCellCellidIndexToSave extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX IF NOT EXISTS save_cell_cellid_idx
      ON bym.save (cell_cellid)
    `);
  }
}
