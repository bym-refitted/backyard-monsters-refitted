import { Migration } from "@mikro-orm/migrations";

/**
 * Add destroyed_at column to world_map_cell to support tribe outpost destruction.
 * When a tribe outpost is defeated at ≥90% damage, destroyed_at is stamped server-side.
 * getCells hides the cell until OUTPOST_REGEN_MS elapses, then lazily deletes it so
 * the generated cell repopulates the position.
 */
export class AddDestroyedAtToWorldMapCell extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."world_map_cell"
      ADD COLUMN IF NOT EXISTS "destroyed_at" TIMESTAMPTZ NULL;
    `);
  }
}
