import { POWERUP_LABEL, SHOUT_TEXT, STANCE_LABEL } from "../../config/AllianceConfig.js";
import { AllianceMessageType, type AllianceStance, type AlliancePowerupType } from "../../enums/Alliance.js";
import type { Alliance } from "../../database/models/alliance.model.js";


type ShoutTarget = Pick<Alliance, "name"> | null;

/**
 * Builds a membership shout: promotions, joins, kicks, departures, creation.
 *
 * @param {string} username - The member the shout is about.
 * @param {AllianceMessageType} type - Which shout to build.
 * @returns {string} The finished sentence, or empty if this type has no text.
 */
const createShoutText = (username: string, type: AllianceMessageType): string => {
  const sentence = SHOUT_TEXT[type];

  if (!sentence) return "";

  return `${username} ${sentence}`;
};

/**
 * Builds a relationship shout.
 *
 * The verb is chosen by whether the name ends in "s", which is what the original
 * did - confirmed against footage of one leader flagging five alliances in a
 * row, where `have` appeared for exactly the two names ending in s.
 *
 * @param {string} allianceName - The alliance that was flagged.
 * @param {AllianceStance} relationship - What it was flagged as.
 * @returns {string} The finished sentence.
 */
const createRelationshipShoutText = (allianceName: string, relationship: AllianceStance) => {
  const verb = allianceName.toLowerCase().endsWith("s") ? "have" : "has";

  return `"${allianceName}" ${verb} been flagged as ${STANCE_LABEL[relationship]}`;
};

/**
 * Builds the shout for a leader starting a power-up.
 *
 * @param {string} username - The leader who activated it.
 * @param {string} body - The stored power-up type.
 * @returns {string} The finished sentence, or empty if the type is unknown.
 */
const createPowerupActivatedText = (username: string, body: string) => {
  const label = POWERUP_LABEL[body as AlliancePowerupType];

  if (!label) return "";

  return `${username} activated the ${label} Power-Up!`;
};

/**
 * Builds the shout for a member spending Shiny on a power-up's charge.
 *
 * @param {string} username - The member who paid.
 * @param {string} body - JSON: the power-up type and hours bought.
 * @returns {string} The finished sentence, or empty if the payload is unusable.
 */
const createPowerupPurchaseText = (username: string, body: string) => {
  let payload: { powerup?: string; hours?: number };

  try {
    payload = JSON.parse(body);
  } catch {
    return "";
  }

  const label = POWERUP_LABEL[payload.powerup as AlliancePowerupType];
  const hours = Number(payload.hours);

  if (!label || !hours) return "";

  return `${username} has reduced the ${label} Power-Up by ${hours} ${hours === 1 ? "hour" : "hours"}.`;
};

/**
 * Picks the right builder for a stored row.
 *
 * The membership shouts are the default: their whole sentence is the author's
 * name plus a fixed suffix. The three cases above it each need something the
 * author does not carry, which is what `body` is for - a relationship shout
 * stores its flag value, an activation the power-up started, a purchase the
 * power-up and the hours bought.
 *
 * @param {AllianceMessageType} type - Which shout this is.
 * @param {string} username - The author, subject of every membership shout.
 * @param {string} body - Whatever the sentence needs beyond the author's name.
 * @param {ShoutTarget} targetAlliance - The flagged alliance, present only on a relationship shout.
 * @returns {string} The finished sentence, or empty if it cannot be built.
 */
export const composeShout = (type: AllianceMessageType, username: string, body: string, targetAlliance?: ShoutTarget) => {
  switch (type) {
    case AllianceMessageType.POWERUP_ACTIVATED:
      return createPowerupActivatedText(username, body);

    case AllianceMessageType.POWERUP_PURCHASE:
      return createPowerupPurchaseText(username, body);

    case AllianceMessageType.RELATIONSHIP:
      if (!targetAlliance) return "";

      return createRelationshipShoutText(targetAlliance.name, Number(body) as AllianceStance);

    default:
      return createShoutText(username, type);
  }
};
