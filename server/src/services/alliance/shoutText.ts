import { SHOUT_TEXT, STANCE_LABEL } from "../../config/AllianceConfig.js";
import { AllianceMessageType, type AllianceStance } from "../../enums/Alliance.js";
import type { Alliance } from "../../models/alliance.model.js";


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
 * Picks the right builder for a stored row.
 *
 * Relationship shouts are the odd one out: their subject is an alliance rather
 * than a member, so the text comes from the joined target and the flag value
 * kept in `body` instead of from the author's name.
 *
 * @param {AllianceMessageType} type - Which shout this is.
 * @param {string} username - The author, subject of every membership shout.
 * @param {string} body - The stored body, carrying the flag value on a relationship shout.
 * @param {ShoutTarget} targetAlliance - The flagged alliance, present only on a relationship shout.
 * @returns {string} The finished sentence, or empty if it cannot be built.
 */
export const composeShout = (type: AllianceMessageType, username: string, body: string, targetAlliance?: ShoutTarget) => {
  if (type !== AllianceMessageType.RELATIONSHIP) return createShoutText(username, type);

  if (!targetAlliance) return "";

  return createRelationshipShoutText(targetAlliance.name, Number(body) as AllianceStance);
};
