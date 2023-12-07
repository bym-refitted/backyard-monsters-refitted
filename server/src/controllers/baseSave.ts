import { Save } from "../models/save.model";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { logging, errorLog } from "../utils/logger";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  logging(`Saving the base! user: ${user.username}`);

  await ORMContext.em.populate(user, ["save"]);
  let save = user.save;

  // Update the save with the values from the request
  for (const key of Save.jsonKeys) {
    const requestBodyValue = ctx.request.body[key];
    if (requestBodyValue) {
      if (!Array.isArray(requestBodyValue)) {
        ctx.request.body[key] = JSON.parse(requestBodyValue);
      }
    }
  }

  logging(`Base save data: ${JSON.stringify(ctx.request.body)}`);

  // Copy the basesaveid
  ctx.session.basesaveid = save.basesaveid;

  // Update resources with the delta sent from the client 
  if (ctx.request.body['resources'] !== undefined) {
    const storeResources = save.resources;
    const clientResources = ctx.request.body['resources'];

    storeResources['r1'] += clientResources['r1'];
    storeResources['r2'] += clientResources['r2'];
    storeResources['r3'] += clientResources['r3'];
    storeResources['r4'] += clientResources['r4'];
    
    storeResources['r1max'] = clientResources['r1max'];
    storeResources['r2max'] = clientResources['r2max'];
    storeResources['r3max'] = clientResources['r3max'];
    storeResources['r4max'] = clientResources['r4max'];

    delete ctx.request.body['resources'];
  }

  // Update building health data with data sent from the client 
  if (ctx.request.body['buildinghealthdata'] === undefined) {
    if (save.buildinghealthdata !== undefined) {
      delete save.buildinghealthdata
    }
  } 
  else {
    save.buildinghealthdata = ctx.request.body['buildinghealthdata'];
  }

  // Update buiding upgrade data with data sent from the client 
  if (ctx.request.body['buildingdata'] !== undefined) {
    save.buildingdata = ctx.request.body['buildingdata'];
  }

  // Update AI attack data
  if (ctx.request.body['aiattacks'] !== undefined) {
    save.aiattacks = ctx.request.body['aiattacks'];

    delete ctx.request.body['aiattacks'];
  }

  // Update 'storedata' with the new purchased item & quantity
  const purchaseString: string | undefined = (ctx.request.body as any)
    ?.purchase;
  
  if (purchaseString) {
    const purchaseArray: [string, number] = JSON.parse(purchaseString);
    const [item, quantity] = purchaseArray;

    const storeData = save.storedata || {};

    storeData[item] = {
      q: (storeData[item]?.q || 0) + quantity,
    };

    save.storedata = storeData;

    // Process purchase cost for shiny usage
    switch (item)
    {
      // Note: we we should check for negative quantity in each of these cases

      // Instant Build
      case "IB":
        logging(`Player purchased Instant Build (cost: ${quantity})`);
        save.credits -= quantity;
        break;

      // Instant Upgrade
      case "IU":
        logging(`Player purchased Instant Upgrade (cost: ${quantity})`);
        save.credits -= quantity;
        break;

      // Instant Fortify
      case "IF":
        logging(`Player purchased Instant Fortify (cost: ${quantity})`);
        save.credits -= quantity;
        break;

      // SP4 (SPeed 4?)

      // Workers
      case "BEW":
        var new_worker_count = (save.storedata['BEW'] !== undefined) ? (save.storedata['BEW']['q'] + 1) : 1;
        logging(`Player purchased worker ${new_worker_count}`);

        switch (new_worker_count) {
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

      // Mushroom with 3 shiny
      case "MUSHROOM1":
        logging(`Player picked MUSHROOM1 (3 shiny)`);

        if (quantity !== 1) {
          errorLog(`Unusual mushroom quantity! Found: ${quantity}. Possible hack?`);
        }

        save.credits += 3;
        break;

      // Mushroom with 8 shiny
      case "MUSHROOM2":
        logging(`Player picked MUSHROOM2 (8 shiny)`);

        if (quantity !== 1) {
          errorLog(`Unusual mushroom quantity! Found: ${quantity}. Possible hack?`);
        }

        save.credits += 8;
        break;

      default:
        logging(`Unhandled purchase! Item: ${item}, quantity: ${quantity}`);
        break;
    }
  }

  // Update the save timestamp
  save.savetime = getCurrentDateTime();
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  // Equivalent to Object.assign() - merges second object onto entity
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
