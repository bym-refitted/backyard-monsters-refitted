import type { User } from "../../database/models/user.model.js";

export interface RadioAlertSettings {
  attackAlerts: boolean;
  newsAlerts: boolean;
}

/**
 * Builds the Radio Tower settings block sent on login and after a settings update.
 *
 * @param {User} user - The player.
 * @returns {RadioAlertSettings} The player's alert settings.
 */
export const radioAlertSettings = (user: User): RadioAlertSettings => ({
  attackAlerts: user.radio_attack_alerts,
  newsAlerts: user.radio_news_alerts,
});
