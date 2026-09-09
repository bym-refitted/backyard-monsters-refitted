import { Filter as BadWords } from "bad-words";

import { allianceDescriptionBannedErr, allianceNameBannedErr } from "../../errors/errors.js";

const filter = new BadWords();

/**
 * Rejects an alliance name containing a banned word.
 *
 * @param {string} name - The proposed alliance name.
 * @throws {ClientSafeError} When the name contains a banned word.
 */
export const assertNameAllowed = (name: string) => {
  if (filter.isProfane(name)) throw allianceNameBannedErr();
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
