import { Migration } from "@mikro-orm/migrations";

/**
 * Adds bym.event.taken_outposts, the base ids of the Outposts a player has taken over in a run
 * of Monster Madness, so each one only scores once per run.
 */
export class AddTakenOutpostsToEvent extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      ALTER TABLE bym.event
        ADD COLUMN IF NOT EXISTS taken_outposts JSONB NOT NULL DEFAULT '[]'
    `);
  }
}
