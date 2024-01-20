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

  // ToDo new: take another look at this
  // Update the save with the values from the request
  for (const key of Save.jsonKeys) {
    const requestBodyValue = ctx.request.body[key];

    switch (key) {
      case "resources":
        // Update resources with the delta sent from the client
        const resources: Resources | undefined = JSON.parse(requestBodyValue);
        const savedResources: FieldData = updateResources(
          resources,
          save.resources || {}
        );
        save.resources = savedResources;
        break;
      case "buildinghealthdata":
        save.buildinghealthdata = JSON.parse(requestBodyValue);
        break;
      case "purchase":
        // Update 'storedata' with the new purchased item & quantity
        if (requestBodyValue) {
          const [item, quantity]: [string, number] =
            JSON.parse(requestBodyValue);

          const storeData: FieldData = save.storedata || {};
          storeData[item] = {
            q: (storeData[item]?.q || 0) + quantity,
          };

          // Determine expiry if the item has a duration
          let storeItem = storeItems[item];
          if ((storeItem?.du ?? 0) > 0) {
            storeData[item].e = getCurrentDateTime() + storeItem.du;
          }

          save.storedata = storeData;
          updateCredits(save, item, quantity);
        }
        break;
      case "academy":
        let academyData = JSON.parse(requestBodyValue);
        for(const [monster, monsterData] of Object.entries<any>(academyData)){
          if(monsterData?.level > 6){
            academyData[monster].level = 6;
          }
        }
        save.academy = academyData;
        break
      default:
        if (
          requestBodyValue &&
          !Array.isArray(requestBodyValue) &&
          requestBodyValue !== undefined
        ) {
          save[key] = JSON.parse(requestBodyValue);
        }
    }
  }
  // Update the save timestamp
  save.savetime = getCurrentDateTime();
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;
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
  };
};
