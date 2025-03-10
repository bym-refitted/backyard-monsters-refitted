import { Context } from "koa";
import { storeItems } from "../../../../data/store/storeItems";
import { Save, FieldData } from "../../../../models/save.model";
import { updateCredits } from "../../../../services/base/updateCredits";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";

export const purchaseHandler = (ctx: Context, purchaseData: [string, number], save: Save) => {
  // Update 'storedata' with the new purchased item & quantity
  if (purchaseData) {
    const [item, quantity] = purchaseData;

    const storeData: FieldData = save.storedata || {};
    storeData[item] = {
      q: (storeData[item]?.q || 0) + quantity,
    };

    // Determine expiry if the item has a duration
    const storeItem = storeItems[item];
    if ((storeItem?.du ?? 0) > 0) {
      storeData[item].e = getCurrentDateTime() + storeItem.du;
    }

    save.storedata = storeData;
    updateCredits(ctx, save, item, quantity);
  }
};
