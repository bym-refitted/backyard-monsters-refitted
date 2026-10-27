import { getActiveInvasion } from "./getActiveInvasion.js";
import { setupInvasionEvent } from "./setupInvasionEvent.js";

/**
 * Gets the current invasion flags.
 * These flags are used to determine the state of Wild Monster Invasion events.
 */
export const getInvasionFlags = () => {
  const activeInvasion = getActiveInvasion();
  const invasionPhases = setupInvasionEvent(activeInvasion).phases;
  
  return { ...invasionPhases, activeInvasion };
};
