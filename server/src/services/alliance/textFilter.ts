import { Filter as BadWords } from "bad-words";

import { ALLIANCE_NAME_MAX_LENGTH, ALLIANCE_NAME_MIN_LENGTH } from "../../config/AllianceConfig.js";
import {
  allianceDescriptionBannedErr,
  allianceNameBannedErr,
  allianceNameTooLongErr,
  allianceNameTooShortErr,
} from "../../errors/errors.js";

const filter = new BadWords();
const LEADING_CHARACTER = /^[\p{L}\p{N}]/u;

/**
 * Rejects an alliance name that is too short, too long, opens with a symbol, or is profane.
 *
 * Checked here rather than in the Zod schema because a failed parse surfaces as
 * a generic support error, while each of these needs a message the player can
 * act on.
 *
 * @param {string} name - The proposed alliance name, already trimmed.
 * @throws {ClientSafeError} When the name breaks any of the rules.
 */
export const assertNameAllowed = (name: string) => {
  if (name.length < ALLIANCE_NAME_MIN_LENGTH) throw allianceNameTooShortErr();
  if (name.length > ALLIANCE_NAME_MAX_LENGTH) throw allianceNameTooLongErr();
  
  if (!LEADING_CHARACTER.test(name) || filter.isProfane(name)) throw allianceNameBannedErr();
};

/**
 * Rejects an alliance description containing a banned word.
 *
 * @param {string} description - The proposed alliance description.
 * @throws {ClientSafeError} When the description contains a banned word.
 */
export const assertDescriptionAllowed = (description: string) => {
  if (filter.isProfane(description)) throw allianceDescriptionBannedErr();
};
