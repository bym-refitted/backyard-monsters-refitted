import { Save } from "../models/save.model";
import { logging } from "../utils/logger";

/**
 *  Keeps track of shiny (credits) spent and obtained.
 * @param {Save} save - The object representing the user's save data.
 * @param {string} item - The item identifier for which credits are spent or obtained.
 * @param {number} quantity - The quantity of the item affecting credit changes.
 */
export const updatedCredits = (save: Save, item: string, quantity: number) => {
  switch (item) {
    case "IB":
    case "IU":
    case "IF":
      save.credits -= quantity;
      break;

    case "BEW":
      const purchaseWorker = (save.storedata["BEW"]?.q || 0) + quantity;
      switch (purchaseWorker) {
        case 2:
          save.credits -= 250;
          break;
        case 3:
          save.credits -= 500;
          break;
        case 4:
          save.credits -= 1000;
          break;
        case 5:
          save.credits -= 2000;
          break;
      }
      break;

    case "ENL":
      const purchaseExpansion = (save.storedata["ENL"]?.q || 0) + quantity;
      switch (purchaseExpansion) {
        case 2:
          save.credits -= 50;
          break;
        case 3:
          save.credits -= 100;
          break;
        case 4:
          save.credits -= 150;
          break;
        case 5:
          save.credits -= 200;
          break;
        case 6:
          save.credits -= 250;
          break;
        case 7:
          save.credits -= 300;
          break;
      }
      break;

    case "MUSHROOM1":
      save.credits += 25;
      break;

    case "MUSHROOM2":
      save.credits += 50;
      break;

    default:
      logging(`Unhandled purchase! Item: ${item}, quantity: ${quantity}`);
      break;
  }
};
