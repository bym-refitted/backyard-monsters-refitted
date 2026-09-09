import { Migration } from "@mikro-orm/migrations";

/**
 * Creates bym.alliance_powerup - one row per alliance per power-up, holding
 * whether it is running and when its current run or charge ends.
 */
export class CreateAlliancePowerupTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE IF NOT EXISTS bym.alliance_powerup (
        alliance_id INTEGER NOT NULL,
        powerup     VARCHAR(32) NOT NULL,
        active      BOOLEAN NOT NULL DEFAULT FALSE,
        end_time    INTEGER NOT NULL,
        updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
        PRIMARY KEY (alliance_id, powerup)
      )
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_powerup
      ADD CONSTRAINT alliance_powerup_type_check
      CHECK (powerup IN ('ap_armament', 'ap_conquest', 'ap_declarewar'))
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_powerup
      DROP CONSTRAINT IF EXISTS alliance_powerup_alliance_id_foreign
    `);

    await this.execute(`
      ALTER TABLE bym.alliance_powerup
      ADD CONSTRAINT alliance_powerup_alliance_id_foreign
      FOREIGN KEY (alliance_id) REFERENCES bym.alliance(id) ON DELETE CASCADE
    `);
  }
}
