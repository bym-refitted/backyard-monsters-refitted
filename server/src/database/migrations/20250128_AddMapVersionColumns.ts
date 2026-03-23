import { Migration } from "@mikro-orm/migrations";

/**
 * Add map_version column to world and world_map_cell tables
 * to support versioned map generation (MR3).
 */
export class AddMapVersionColumns extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."world_map_cell"
      ADD COLUMN IF NOT EXISTS "map_version" INTEGER DEFAULT 2;

      DROP INDEX IF EXISTS "bym"."world_map_cell_world_id_x_y_index";

      CREATE INDEX IF NOT EXISTS "idx_world_map_cell_world_map_version_xy"
      ON "bym"."world_map_cell" ("world_id", "map_version", "x", "y");

      ALTER TABLE "bym"."world"
      ADD COLUMN IF NOT EXISTS "map_version" INTEGER DEFAULT 2;

      UPDATE "bym"."world" SET "map_version" = 2 WHERE "map_version" IS NULL;
    `);
  }
}
