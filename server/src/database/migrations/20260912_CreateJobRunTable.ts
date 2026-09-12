import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.job_run, the record of which periodic jobs have run for which period.
 *
 * The composite primary key is the guard: monthly-shiny claims (job, period) in
 * the same transaction that grants the credits, so a second run on the same day
 * fails on the key and grants nothing.
 */
export class CreateJobRunTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.job_run (
        job     VARCHAR(255) NOT NULL,
        period  VARCHAR(255) NOT NULL,
        ran_at  TIMESTAMP NOT NULL DEFAULT NOW(),
        PRIMARY KEY (job, period)
      )
    `);
  }
}
