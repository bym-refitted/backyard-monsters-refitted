import type { JsonObject } from "../../types/JsonObject.js";
import { extractTownHall } from "../../utils/extractTownHall.js";

type Buildings = JsonObject | null | undefined;

/**
 * Whether saving incoming over stored would lower the yard's Town Hall level.
 * A Town Hall can never go down a level, so a save that does this came from a client
 * whose yard was not loaded, such as an empty yard or the client's default buildings.
 *
 * @param {Buildings} stored - The yard's buildings in the database
 * @param {Buildings} incoming - The buildings sent by the client, absent when the save leaves them alone
 * @returns {boolean} True when the stored Town Hall is higher than the incoming one, or the incoming has none
 */
export const lowersTownHall = (stored: Buildings, incoming: Buildings) => {
  if (!incoming) return false;

  const storedTownHall = stored ? extractTownHall(stored) : null;
  if (!storedTownHall) return false;

  const incomingTownHall = extractTownHall(incoming);
  const incomingLevel = incomingTownHall ? incomingTownHall.l : 0;

  return incomingLevel < storedTownHall.l;
};
