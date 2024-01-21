import { Save } from "../models/save.model";
import { errorLog } from "../utils/logger";
import { StoreItem, storeItems } from "./storeItems";

interface Mushrooms {
  MUSHROOM1: number;
  MUSHROOM2: number;
}

/**
 *  Keeps track of shiny (credits) spent and obtained.
 * @param {Save} save - The object representing the user's save data.
 * @param {string} item - The item identifier for which credits are spent or obtained.
 * @param {number} quantity - The quantity of the item affecting credit changes.
 */
export const updateCredits = (save: Save, item: string, quantity: number) => {
  if (quantity <= 0) {
    errorLog(`Invalid purchase quantity! Item: ${item}, quantity: ${quantity}`);
    return;
  }

  // Handle mushrooms
  const mushroomCredits: Mushrooms = { MUSHROOM1: 25, MUSHROOM2: 50 };
  if (item in mushroomCredits) {
    save.credits += mushroomCredits[item];
    return;
  }

  // Handle non-store purchases
  const nonStoreItem = new Set(["IU", "IF", "ITR", "IUN", "IPU"]);
  if (nonStoreItem.has(item)) {
    save.credits -= quantity;
    return;
  }

  // Handle store purchases
  const storeItem: StoreItem = storeItems[item];
  if (!storeItem.c) {
    errorLog("Not a store item! Add to non-store items list", item);
  }
  let itemCost: number = storeItem.c[0];
  if (storeItem.c.length > 1) {
    // The item has a scaling cost depending on how many of that item the player currently owns
    // We subtract 1 here since the item would've been already added to the player's save by the caller
    const currentQuantity: number = save.storedata[item].q - 1;
    itemCost = storeItem.c[currentQuantity];
  }

  save.credits -= itemCost * quantity;
};
