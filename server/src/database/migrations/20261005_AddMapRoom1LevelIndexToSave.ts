import { Migration } from "@mikro-orm/migrations";

/**
 * Indexes Map Room 1 main bases by level and how recently they were played, for
 * the neighbour search - which wants recently played players within a level
 * range and reads nothing from the row but the user id.
 */
export class AddMapRoom1LevelIndexToSave extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE INDEX IF NOT EXISTS save_mr1_level_savetime_index
      ON bym.save (level, savetime DESC) INCLUDE (userid)
      WHERE type = 'main' AND mapversion = 1
    `);
  }
}
