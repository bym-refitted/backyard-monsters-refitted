import path from "path";

import type { Save } from "../../database/models/save.model.js";
import type { User } from "../../database/models/user.model.js";
import { BaseType } from "../../enums/Base.js";
import { transporter } from "../../config/MailConfig.js";
import { redis } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { logger } from "../../utils/logger.js";
import { unsubscribeLink } from "./unsubscribeLink.js";

const ALERTS_PER_DAY = 2;

const ONLINE_WINDOW_SECONDS = 60;

const TEMPLATE_PATH = path.resolve(import.meta.dirname, "../../../public/templates/attack-alert.html");

/**
 * Whether the player has been seen in their main yard or Inferno within the online window.
 *
 * @param {number} userid - The player.
 * @returns {Promise<boolean>} True when the player is playing.
 */
const isOnline = async (userid: number): Promise<boolean> => {
  const lastSeen = await redis.mget(`last-seen:${BaseType.MAIN}:${userid}`, `last-seen:${BaseType.INFERNO}:${userid}`);
  const cutoff = getCurrentDateTime() - ONLINE_WINDOW_SECONDS;

  return lastSeen.some((seen) => seen !== null && parseInt(seen) >= cutoff);
};

/**
 * Counts an alert against the player's daily allowance.
 *
 * @param {number} userid - The player.
 * @returns {Promise<boolean>} True when the alert is within today's (UTC) allowance.
 */
const countDailyAlert = async (userid: number): Promise<boolean> => {
  const key = `radio-alert:${userid}:${new Date().toISOString().slice(0, 10)}`;
  const count = await redis.incr(key);

  if (count === 1) await redis.expire(key, 24 * 60 * 60);

  return count <= ALERTS_PER_DAY;
};

/**
 * Whether the defender should get an attack alert: alerts on, not online, and within the
 * daily allowance. The allowance is checked last so skipped alerts don't count against it.
 *
 * @param {User} defender - The player being attacked.
 * @returns {Promise<boolean>} True when an alert should be sent.
 */
const canReceiveAlert = async (defender: User): Promise<boolean> => {
  const { userid, radio_attack_alerts } = defender;

  if (!radio_attack_alerts) return false;

  const online = await isOnline(userid);

  if (online) return false;

  return countDailyAlert(userid);
};

/**
 * Describes the attacked base for the email.
 *
 * @param {Save} save - The base being attacked.
 * @returns {string} e.g. "your yard" or "your outpost at (120, 45)".
 */
const attackDetails = (save: Save): string => {
  if (save.type === BaseType.INFERNO) return "your Inferno yard";
  if (save.type !== BaseType.OUTPOST) return "your yard";

  const { x, y } = save.cell!;

  return `your outpost at (${x}, ${y})`;
};

/**
 * Emails the defender a Radio Tower attack alert when an attack starts.
 *
 * The checks in canReceiveAlert are awaited, the send is not, so a slow mail server never
 * delays the attack load. Never throws.
 *
 * @param {User} attacker - The player starting the attack.
 * @param {User} defender - The player being attacked.
 * @param {Save} save - The base being attacked.
 * @returns {Promise<void>}
 */
export const sendAttackAlert = async (attacker: User, defender: User, save: Save): Promise<void> => {
  try {
    const canReceive = await canReceiveAlert(defender);

    if (!canReceive) return;

    const attackerName = Bun.escapeHTML(attacker.username);
    const baseName = attackDetails(save);
    
    const playLink = process.env.WEB_URL!;
    const cdnUrl = process.env.CDN_URL!;
    const unsubscribe = unsubscribeLink(defender.userid);

    const template = await Bun.file(TEMPLATE_PATH).text();

    const html = template
      .replace("{{attackerName}}", attackerName)
      .replace("{{baseName}}", baseName)
      .replace("{{playLink}}", playLink)
      .replace("{{unsubscribeLink}}", unsubscribe)
      .replaceAll("{{cdnUrl}}", cdnUrl);

    transporter
      .sendMail({
        from: "Backyard Monsters Refitted <info@bymrefitted.com>",
        to: defender.email,
        subject: `${attacker.username} is attacking ${baseName}! | BYM Refitted`,
        text: `${attacker.username} is attacking ${baseName}!\n\nPlay now: ${playLink}\n\nYou are getting this because Attack Alerts are switched on in your Radio Tower. Unsubscribe: ${unsubscribe}`,
        html,
        headers: {
          "List-Unsubscribe": `<${unsubscribe}>`,
          "List-Unsubscribe-Post": "List-Unsubscribe=One-Click",
        },
      })
      .catch((error) => {
        logger.error("Attack alert email to user {userid} failed: {error}", { userid: defender.userid, error: String(error) });
      });
  } catch (error) {
    logger.error("Attack alert for user {userid} failed: {error}", { userid: defender.userid, error: String(error) });
  }
};
