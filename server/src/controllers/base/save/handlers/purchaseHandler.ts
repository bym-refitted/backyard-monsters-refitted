import { Context } from "koa";
import { storeItems } from "../../../../data/storeItems";
import { SaveKeys } from "../../../../enums/SaveKeys";
import { Save, FieldData } from "../../../../models/save.model";
import { updateCredits } from "../../../../services/base/updateCredits";

export const purchaseHandler = (ctx: Context, userSave: Save, save: Save) => {
  const purchaseData = ctx.request.body[SaveKeys.PURCHASE];

  // Update 'storedata' with the new purchased item & quantity
  if (purchaseData) {
    const [item, quantity]: [string, number] = JSON.parse(purchaseData);

    const storeData: FieldData = save.storedata || {};
    storeData[item] = {
      q: (storeData[item]?.q || 0) + quantity,
    };

    // Determine expiry if the item has a duration
    const storeItem = storeItems[item];
    if ((storeItem?.du ?? 0) > 0) {
      storeData[item].e = Date.now() + storeItem.du;
    }

    save.storedata = storeData;
    updateCredits(userSave, item, quantity);
  }
};
