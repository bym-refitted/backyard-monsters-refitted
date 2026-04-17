import { Migration } from "@mikro-orm/migrations";

/**
 * Creates the maproom table for MR1 overworld neighbour caching.
 */
export class AddMaproomTable extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      CREATE TABLE "bym"."maproom" (
        "userid" int NOT NULL,
        "neighbors" jsonb NOT NULL DEFAULT '[]',
        "neighbors_last_calculated" timestamptz NULL,
        "created_at" timestamptz NOT NULL DEFAULT now(),
        "lastupdate_at" timestamptz NOT NULL DEFAULT now(),
        CONSTRAINT "maproom_pkey" PRIMARY KEY ("userid")
      );
    `);
  }

  async down(): Promise<void> {
    this.addSql(`DROP TABLE IF EXISTS "bym"."maproom";`);
  }
}
