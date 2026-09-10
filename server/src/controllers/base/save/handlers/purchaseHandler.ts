import type { Context } from "koa";
import { storeItems } from "../../../../game-data/store/storeItems.js";
import { Save } from "../../../../models/save.model.js";
import { updateCredits } from "../../../../services/base/updateCredits.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import { isShinyLocked } from "../../../../services/user/shinyLock.js";
import { isShinyGain } from "../../../../game-data/store/purchaseKeys.js";
import { shinyLockedErr } from "../../../../errors/errors.js";
import type { JsonObject } from "../../../../types/JsonObject.js";

/**
 * Applies a purchase to the save: grants the item, sets any expiry, then settles the cost.
 *
 * @param {Context} ctx - The Koa context object
 * @param {[string, number]} purchaseData - The item key and quantity sent by the client
 * @param {Save} save - The save the purchase applies to
 * @throws {ClientSafeError} If a locked account tries to spend shiny
 */
export const purchaseHandler = (ctx: Context, purchaseData: [string, number], save: Save) => {
  if (!purchaseData) return;

  const [item, quantity] = purchaseData;

  const isGain = isShinyGain(item);
  const shinyLocked = isShinyLocked(ctx.authUser);

  if (shinyLocked && !isGain) throw shinyLockedErr();

  const currentTime = getCurrentDateTime();

  const storeData: JsonObject = save.storedata || {};
  storeData[item] = {
    q: (storeData[item]?.q || 0) + quantity,
  };

  // Determine expiry if the item has a duration
  const storeItem = storeItems[item];
  if ((storeItem?.du ?? 0) > 0) {
    storeData[item].e = currentTime + storeItem.du;
  }

  save.storedata = storeData;

  // Apply damage protection for protection items, stacking onto any existing active protection
  if (item === "PRO1" || item === "PRO2" || item === "PRO3") {
    const baseTime = save.protected > currentTime ? save.protected : currentTime;

    save.protected = baseTime + storeItem.du * quantity;
  }

  updateCredits(ctx, save, item, quantity);
};
