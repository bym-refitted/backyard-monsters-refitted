import { Save } from "../../models/save.model.js";
import { logger } from "../../utils/logger.js";
import { type StoreItem, storeItems } from "../../game-data/store/storeItems.js";
import { mushroomCredits, purchaseKeys, rewardCredits } from "../../game-data/store/purchaseKeys.js";
import { User } from "../../models/user.model.js";
import { isShinyLocked } from "../user/shinyLock.js";
import type { Context } from "koa";

/**
 *  Keeps track of shiny (credits) spent and obtained.
 *
 * A locked account still collects mushrooms and quest rewards - those land in the stored
 * balance and surface when the option is switched off. Only the spending branches below
 * are refused.
 *
 * @param {Save} save - The object representing the user's save data.
 * @param {string} item - The item identifier for which credits are spent or obtained.
 * @param {number} quantity - The quantity of the item affecting credit changes.
 */
export const updateCredits = (ctx: Context, save: Save, item: string, quantity: number) => {
  const user: User = ctx.authUser;
  const userSave = user.save!;

  if (quantity <= 0) {
    logger.error("Invalid purchase quantity!", { item, quantity });
    return;
  }

  // Handle mushrooms
  if (item in mushroomCredits) {
    userSave.credits += mushroomCredits[item];
    return;
  }

  // Handle quest rewards that grant credits
  if (item in rewardCredits) {
    const collected = (save.storedata?.[item]?.q ?? 0) > quantity;

    if (!collected) userSave.credits += rewardCredits[item];
    return;
  }

  const shinyLocked = isShinyLocked(user);
  
  if (shinyLocked) return;

  // Handle purchases not in the store
  if (purchaseKeys.has(item)) {
    userSave.credits -= quantity;
    return;
  }

  // Handle store purchases
  const storeItem: StoreItem = storeItems[item];

  if (!storeItem?.c) {
    logger.error(`Not a store item! Add to non-store items list ${item}`);
    return;
  }

  let itemCost: number = storeItem.c[0];

  if (storeItem.c.length > 1) {
    // The item has a scaling cost depending on how many of that item the player currently owns
    // We subtract 1 here since the item would've been already added to the player's save by the caller
    const currentQuantity: number = save.storedata?.[item].q - 1;
    itemCost = storeItem.c[currentQuantity];
  }

  userSave.credits -= itemCost * quantity;
};