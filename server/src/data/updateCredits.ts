import { Save } from "../models/save.model";
import { errorLog } from "../utils/logger";
import { storeItems } from "./storeItems";

/**
 *  Keeps track of shiny (credits) spent and obtained.
 * @param {Save} save - The object representing the user's save data.
 * @param {string} item - The item identifier for which credits are spent or obtained.
 * @param {number} quantity - The quantity of the item affecting credit changes.
 */
export const updatedCredits = (save: Save, item: string, quantity: number) => {
  if (quantity <= 0) {
    errorLog(`PLayer tried to purchase an invalid quantity! Name: ${item}, quantity: ${quantity}`);
    return;
  }

  /* Manual handling for mushrooms, since they aren't in the store */
  if (item == "MUSHROOM1") {
    save.credits += 25;
    return;
  }

  if (item == "MUSHROOM2") {
    save.credits += 50;
    return;
  }

  /* XXX: Aren't in storeItems for some reason? Should we add them? */
  if (item == "IU" ||
      item == "IF") {
    save.credits -= quantity;
    return;
  }

  const storeItem = storeItems[item];

  if (storeItem === undefined) {
    errorLog(`Player tried to purchase an unknown item! Name: ${item}, quantity: ${quantity}`);
    return;
  }

  var itemCost = storeItem.c[0];

  if (storeItem.c.length > 1) {
    /* The item has a scaling cost depending on how many of that item the player currently owns */
    /* We subtract 1 here since the item will've been already added to the player's save by the caller */
    var currentQuantity = save.storedata[item].q - 1;
    itemCost = storeItem.c[currentQuantity];
  }

  /* Multiply the cost by the quantity purchased */
  itemCost *= quantity;

  save.credits -= itemCost;
};
