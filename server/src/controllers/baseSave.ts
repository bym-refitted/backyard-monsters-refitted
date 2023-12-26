import { updateCredits } from "../data/updateCredits";
import { Resources, updateResources } from "../data/updateResources";
import { FieldData, Save } from "../models/save.model";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { logging } from "../utils/logger";
import { storeItems } from "../data/storeItems";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  logging(`Saving the base! user: ${user.username}`);

  await ORMContext.em.populate(user, ["save"]);
  let save = user.save;
  ctx.session.basesaveid = save.basesaveid;

  // Update the save with the values from the request
  for (const key of Save.jsonKeys) {
    const requestBodyValue = ctx.request.body[key];

    if (requestBodyValue && !Array.isArray(requestBodyValue)) {
      ctx.request.body[key] = JSON.parse(requestBodyValue);
    }
  }

  // Update 'storedata' with the new purchased item & quantity
  const purchaseString: string | undefined = (ctx.request.body as any)?.purchase;
  if (purchaseString) {
    const [item, quantity]: [string, number] = JSON.parse(purchaseString);

    const storeData: FieldData = save.storedata || {};
    storeData[item] = {
      q: (storeData[item]?.q || 0) + quantity
    };

    // Determine expiry if the item has a duration 
    let storeItem = storeItems[item];
    if (storeItem?.du ?? 0 > 0) {
      storeData[item].e = getCurrentDateTime() + storeItem.du;
    }

    save.storedata = storeData;
    updateCredits(save, item, quantity);
  }

  // Update resources with the delta sent from the client
  const resources: Resources | undefined = (ctx.request.body as any)?.resources;
  const savedResources: FieldData = updateResources(
    resources,
    save.resources || {}
  );
  save.resources = savedResources;
  delete (ctx.request.body as any)?.resources;

  // Update building health data
  if (ctx.request.body["buildinghealthdata"] === undefined) {
    if (save.buildinghealthdata !== undefined) {
      delete save.buildinghealthdata;
    }
  } else {
    save.buildinghealthdata = ctx.request.body["buildinghealthdata"];
  }

  // Update buiding data
  if (ctx.request.body["buildingdata"] !== undefined) {
    save.buildingdata = ctx.request.body["buildingdata"];
  }

  // Update AI attack data
  if (ctx.request.body["aiattacks"] !== undefined) {
    save.aiattacks = ctx.request.body["aiattacks"];

    delete ctx.request.body["aiattacks"];
  }

  // WARNING: This is currently breaking wild monster attacks, cannot read property of undefined 'time'
  // Update monster academy data
  // let academyData = ctx.request.body["academy"];
  // if (academyData !== undefined) {
  //   for (var item in academyData) {
  //     logging(`Found monster ${item}`);

  //     if (academyData[item]["time"] === undefined &&
  //         save.academy[item]["time"] !== undefined) {
  //       delete save.academy[item]["time"];
  //     }
  //     if (academyData[item]["duration"] === undefined &&
  //         save.academy[item]["duration"] !== undefined) {
  //       delete save.academy[item]["duration"];
  //     }
  //   }
  // }

  // Update the save timestamp
  save.savetime = getCurrentDateTime();
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  // ToDo: This needs to be revisted, we should not be merging these objects for everything
  // e.g. the client deletes certain properties on an object, however it never gets deleted properly here
  // because we merge instead of replace.
  ORMContext.em.assign(save, ctx.request.body);
  await ORMContext.em.persistAndFlush(save);

  const filteredSave = FilterFrontendKeys(save);
  const baseSaveData = {
    error: 0,
    basesaveid: save.basesaveid,
    installsgenerated: 42069,
  };

  ctx.status = 200;
  ctx.body = {
    ...baseSaveData,
    ...filteredSave,
    h: "someHashValue",
  };
};
