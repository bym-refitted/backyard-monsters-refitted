import type { Save } from "../../models/save.model.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";

/**
 * Removes store items from a save once their cooldown has elapsed.
 *
 * The client decides an item is sold out by comparing storedata[item].q against the
 * item's cost tiers; it never looks at the expiry. An elapsed entry therefore has to
 * disappear or the item stays unpurchasable forever.
 *
 * @param {Save} save - The save to clear expired items from.
 * @returns {boolean} Whether anything was removed, so callers can skip a needless flush.
 */
export const clearExpiredStoreItems = (save: Save): boolean => {
  const storeData = save.storedata;

  if (!storeData) return false;

  const currentTime = getCurrentDateTime();
  let cleared = false;

  for (const item of Object.keys(storeData)) {
    const entry = storeData[item];

    if (entry?.e && entry.e <= currentTime) {
      delete storeData[item];
      cleared = true;
    }
  }

  return cleared;
};
