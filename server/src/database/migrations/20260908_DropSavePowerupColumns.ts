import { Migration } from "@mikro-orm/migrations";

/**
 * Drops save.powerups and save.attpowerups.
 *
 * Power-ups belong to an alliance, not to a save - they live in
 * bym.alliance_powerup and are resolved per request. These columns were a
 * per-save copy that nothing ever wrote: every row held an empty array.
 */
export class DropSavePowerupColumns extends Migration {
  async up(): Promise<void> {
    await this.execute(`ALTER TABLE bym.save DROP COLUMN IF EXISTS powerups`);
    await this.execute(`ALTER TABLE bym.save DROP COLUMN IF EXISTS attpowerups`);
  }
}
