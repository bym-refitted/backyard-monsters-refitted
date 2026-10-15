import { Save } from "../../../../database/models/save.model.js";
import type { KrallenClientData } from "../../../../schemas/KrallenSchema.js";

/**
 * Stores the one part of the Hunt for Krallen data the client owns: the highest mid-round
 * popup it has shown. Everything else is decided by the server, so the rest is ignored.
 *
 * @param {KrallenClientData | undefined} reported - The krallen data the client saved
 * @param {Save} save - The save being written
 */
export const krallenHandler = (reported: KrallenClientData | undefined, save: Save) => {
  if (!reported || !save.krallen) return;

  save.krallen = { ...save.krallen, lastShownTier: reported.lastShownTier };
};
