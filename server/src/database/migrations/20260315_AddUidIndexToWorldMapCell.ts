import { Migration } from "@mikro-orm/migrations";

/**
 * Add index on uid column of world_map_cell.
 * Required for efficient lookups of all cells owned by a player (initialPlayerCellData),
 * and for the defender buff query in baseLoad (filtering by uid + base_type + map_version).
 * Without this index both queries do a full table scan.
 */
export class AddUidIndexToWorldMapCell extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE INDEX IF NOT EXISTS "idx_world_map_cell_uid"
      ON "bym"."world_map_cell" ("uid");
    `);
  }
}
