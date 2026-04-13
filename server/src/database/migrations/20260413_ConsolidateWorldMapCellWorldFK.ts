import { Migration } from "@mikro-orm/migrations";

/**
 * Consolidates the two redundant world-reference columns on world_map_cell into one.
 *
 * Previously the model had both:
 *   - world_id  (plain @Property string — no FK constraint, used in all ORM queries)
 *   - world_uuid (@ManyToOne FK column — had the FK constraint, never queried directly)
 *
 * The @ManyToOne decorator now uses fieldName: 'world_id', so world_id is the single
 * canonical FK column. This migration drops world_uuid and adds the FK constraint to
 * world_id to restore referential integrity.
 */
export class ConsolidateWorldMapCellWorldFK extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."world_map_cell"
        DROP CONSTRAINT IF EXISTS "world_map_cell_world_uuid_foreign";

      ALTER TABLE "bym"."world_map_cell"
        DROP COLUMN IF EXISTS "world_uuid";

      ALTER TABLE "bym"."world_map_cell"
        ADD CONSTRAINT "world_map_cell_world_id_foreign"
        FOREIGN KEY ("world_id") REFERENCES "bym"."world" ("uuid")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
    `);
  }
}
