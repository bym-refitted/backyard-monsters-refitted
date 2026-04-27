import { Migration } from "@mikro-orm/migrations";

/**
 * Migration to add truce_id and trucestate fields to the thread table.
 * This allows us to link threads to truces and track their status.
 */
export class Migration20260427_AddTruceFieldsToThread extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      ALTER TABLE bym.thread
        ADD COLUMN truce_id INTEGER,
        ADD COLUMN trucestate VARCHAR(10)
    `);

    await this.execute(`
      CREATE INDEX thread_truce_id_idx ON bym.thread (truce_id)
    `);
  }
}
