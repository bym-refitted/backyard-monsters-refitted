import { Migration } from "@mikro-orm/migrations";

/**
 * Adds Map Room 1 support:
 * - Creates the maproom table for MR1 overworld neighbour caching and tribe health tracking.
 * - Adds mapversion column to save table and backfills MR2/MR3 players from their world's map_version.
 * - Adds mr2upgraded column to save table to track first-time MR2 upgrades.
 * - Backfills all existing main yards to true so existing players skip the 4-day timer.
 */
export class AddMapRoom1Support extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE TABLE IF NOT EXISTS "bym"."maproom" (
        "userid" int NOT NULL,
        "tribedata" jsonb NULL DEFAULT '[]',
        "neighbors" jsonb NOT NULL DEFAULT '[]',
        "neighbors_last_calculated" timestamptz NULL,
        "created_at" timestamptz NOT NULL DEFAULT now(),
        "lastupdate_at" timestamptz NOT NULL DEFAULT now(),
        CONSTRAINT "maproom_pkey" PRIMARY KEY ("userid")
      );
    `);

    this.addSql(`ALTER TABLE "bym"."save" ADD COLUMN IF NOT EXISTS "mapversion" int NULL;`);

    this.addSql(`
      UPDATE "bym"."save" s
      SET "mapversion" = w."map_version"
      FROM "bym"."world" w
      WHERE s."worldid" = w."uuid"
        AND s."type" = 'main';
    `);

    this.addSql(
      `ALTER TABLE "bym"."save" ADD COLUMN IF NOT EXISTS "mr2upgraded" boolean NOT NULL DEFAULT false;`,
    );

    this.addSql(
      `UPDATE "bym"."save" SET "mr2upgraded" = true WHERE "type" = 'main';`,
    );
  }
}