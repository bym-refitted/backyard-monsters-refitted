import { Migration } from "@mikro-orm/migrations";

/**
 * Adds the player's Radio Tower email alert settings to bym.user.
 */
export class AddRadioAlertsToUser extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      ALTER TABLE bym."user"
        ADD COLUMN IF NOT EXISTS radio_attack_alerts BOOLEAN NOT NULL DEFAULT FALSE,
        ADD COLUMN IF NOT EXISTS radio_news_alerts BOOLEAN NOT NULL DEFAULT FALSE
    `);
  }
}
