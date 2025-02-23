import { Save } from "../../models/save.model";
import { errorLog } from "../../utils/logger";
import { StoreItem, storeItems } from "../../data/storeItems";

interface Mushrooms {
  MUSHROOM1: number;
  MUSHROOM2: number;
}

/**
 *  Keeps track of shiny (credits) spent and obtained.
 * @param {Save} userSave - The object representing the user's save data.
 * @param {string} item - The item identifier for which credits are spent or obtained.
 * @param {number} quantity - The quantity of the item affecting credit changes.
 */
export const updateCredits = (userSave: Save, item: string, quantity: number) => {
  if (quantity <= 0) {
    errorLog(`Invalid purchase quantity! Item: ${item}, quantity: ${quantity}`);
    return;
  }

  // Handle mushrooms
  const mushroomCredits: Mushrooms = { MUSHROOM1: 3, MUSHROOM2: 8 };
  if (item in mushroomCredits) {
    userSave.credits += mushroomCredits[item];
    return;
  }

  // Handle non-store purchases
  const nonStoreItem = new Set([
    "IU",
    "IF",
    "IFD",
    "ITR",
    "IUN",
    "IPU",
    "IEV",
    "IHE",
    "BRTOPUP",
    "MHTOPUP",
    "HSM",
    "QWM1",
    "IFD",
    "BUNK",
    "KIT",
    "QINVITE1",
    "QINVITE5",
    "QINVITE10"
  ]);
  if (nonStoreItem.has(item)) {
    userSave.credits -= quantity;
    return;
  }

  // Handle store purchases
  const storeItem: StoreItem = storeItems[item];
  if (!storeItem?.c) {
    errorLog("Not a store item! Add to non-store items list", item);
    return;
  }

  // Ensure store item exists in storedata
  if (!userSave.storedata[item]) userSave.storedata[item] = { q: 0 };

  // Now that we are sure it exists, update its quantity
  userSave.storedata[item].q += quantity;

  let itemCost: number = storeItem.c[0];
  if (storeItem.c.length > 1) {
    // The item has a scaling cost depending on how many of that item the player currently owns
    // We subtract 1 here since the item would've been already added to the player's save by the caller
    const currentQuantity: number = userSave.storedata[item].q - 1;
    itemCost = storeItem.c[currentQuantity];
  }

  userSave.credits -= itemCost * quantity;
};
