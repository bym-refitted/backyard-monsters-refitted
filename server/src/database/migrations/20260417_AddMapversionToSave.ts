import { Migration } from "@mikro-orm/migrations";

/**
 * Adds mapversion column to save table and backfills MR2/MR3 players from their world's map_version.
 * MR1 players cannot be backfilled (indistinguishable from no-map-room) and will need to re-select MR1.
 */
export class AddMapversionToSave extends Migration {
  async up(): Promise<void> {
    this.addSql(`ALTER TABLE "bym"."save" ADD COLUMN "mapversion" int NULL;`);

    this.addSql(`
      UPDATE "bym"."save" s
      SET "mapversion" = w."map_version"
      FROM "bym"."world" w
      WHERE s."worldid" = w."uuid"
        AND s."type" = 'main';
    `);
  }
}
