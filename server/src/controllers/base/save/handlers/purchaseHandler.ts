import type { Context } from "koa";
import { storeItems } from "../../../../game-data/store/storeItems.js";
import { Save } from "../../../../models/save.model.js";
import { updateCredits } from "../../../../services/base/updateCredits.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import type { JsonObject } from "../../../../types/JsonObject.js";

export const purchaseHandler = (ctx: Context, purchaseData: [string, number], save: Save) => {
  const currentTime = getCurrentDateTime();

  if (purchaseData) {
    const [item, quantity] = purchaseData;

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
  }
};
