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
import { saveFailureErr } from "../errors/errorCodes.";
import { monsterUpdateBases } from "../services/base/monster";
import { DescentStatus } from "../models/descentstatus.model";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"])
  const authSave = user.save;
  const basesaveid = ctx.request.body["basesaveid"]
  logging(`Saving user's base: ${user.username} | IP Address: ${ctx.ip} | Base ID: ${basesaveid}`);

  if (!basesaveid) throw saveFailureErr

  const save = await ORMContext.em.findOne(Save, {
    basesaveid: parseInt(basesaveid)
  })

  if (!save) throw saveFailureErr;

  const isOutpost = save.saveuserid === user.userid && save.homebaseid != save.basesaveid;
  const descentBases: number[] = [201,202,203,204,205,206,207];

  //logging(Save.jsonKeys.toString());
  // ToDo: Beta clean this shit up
  // Update the save with the values from the request
  for (const key of Save.jsonKeys) {
    const requestBodyValue = ctx.request.body[key];
    //logging(key + ": " + requestBodyValue);

    switch (key) {
      case "resources":
        // Update resources with the delta sent from the client
        const resources: Resources | undefined = JSON.parse(requestBodyValue);
        let sr = isOutpost ? authSave.resources : save.resources;
        const savedResources: FieldData = updateResources(
          resources,
          sr || {}
        );
        if (isOutpost) {
          authSave.resources = savedResources;
        } else {
          save.resources = savedResources;
        }
        break;
      case "buildinghealthdata":
        if (requestBodyValue)
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
          updateCredits(isOutpost ? authSave : save, item, quantity);
        }
        break;
      case "academy":
        let academyData = JSON.parse(requestBodyValue);
        for (const [monster, monsterData] of Object.entries<any>(academyData)) {
          if (monsterData?.level > 6) {
            academyData[monster].level = 6;
          }
        }
        save.academy = academyData;
        break;
      case "type":
        
        break;
      default:
        if (
          requestBodyValue &&
          !Array.isArray(requestBodyValue) &&
          requestBodyValue !== undefined
        ) {
          save[key] = JSON.parse(requestBodyValue);
        }
    }

    if (key === "buildingresources" && isOutpost) {
      authSave.buildingresources[`b${save.baseid}`] = save.buildingresources[`b${save.baseid}`];
    }
  }

  for (const key in <object>ctx.request.body) {
    if (Save.nonJsonKeys.includes(key) && !Save.jsonKeys.includes(key)) {
      if (ctx.request.body[key] !== null) {
        let data = ctx.request.body[key];
        save[key] = data;
      }
    }
  }

  
  if (descentBases.includes(parseInt(basesaveid))) {
    logging("hello");
    logging(save.destroyed + "");
    try {
      if (save.destroyed == 1) {
        /*
        The idea: 
          the typical WMStatus will break the WMBASE.CheckQuests() function
          [[201,1,0],[202,2,0],[203,3,0],[204,4,0],[205,5,0],[206,6,0],[207,7,0]]
          so we create a new table with only 2 fields: userid and wmstatus, where 
          userid is a user's ID, and wmstatus by default being the descent bases

          so we're trying something silly here: using this separate table to stand-in base
          IDs for descent bases when the game wants to access them, since they're only really 
          useful specifically when the player is in the descent. 

          There are possible problems here, but I feel like this is a viable method?
        */
        let baseIndex = descentBases.indexOf(save.basesaveid)
        let userDescentBases = await ORMContext.em.findOne(DescentStatus, {
          userid: authSave.userid,
        })
        if (userDescentBases) {
          logging(userDescentBases.userid + ": " + userDescentBases.wmstatus);
          let stored_base = userDescentBases.wmstatus[baseIndex];
          stored_base[2] = 1;
          userDescentBases[baseIndex] = stored_base;
          await ORMContext.em.persistAndFlush(userDescentBases);
        }
      }
    } catch(error) {
      logging("wtf happened?: " + error);
    }
   
  }
  /*
    Assume that base save is in attack mode
    Save attacker data
  */
  if (save.basesaveid !== authSave.basesaveid && (save.attackid != 0) && save.saveuserid !== user.userid) {
    if (ctx.request.body.hasOwnProperty("attackerchampion")) {
      authSave.champion = ctx.request.body["attackerchampion"];
    }
    if (save.monsterupdate.length > 0) {
      const authMonsters = save.monsterupdate.find(({ baseid }) => baseid == authSave.baseid);
      const monsterUpdates = save.monsterupdate.filter(({ baseid }) => baseid != authSave.baseid);
      if (authMonsters) {
        authSave.monsters = authMonsters.m;
      }
      if (monsterUpdates.length > 0) {
        await monsterUpdateBases(monsterUpdates)
      }

    }
    const resources = <Resources>save.attackloot;
    const savedResources: FieldData = updateResources(
      resources,
      authSave.resources || {}
    );
    authSave.resources = savedResources;
    await ORMContext.em.persistAndFlush(authSave)
  }

  save.attackid = ctx.request.body['over'] ? 0 : save.attackid;
  if (ctx.request.body.hasOwnProperty('over')) {
    save.protected = ctx.request.body['destroyed'];
  }

  // Update the save timestamp
  save.savetime = getCurrentDateTime();
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;
  await ORMContext.em.persistAndFlush(save);

  if (isOutpost) {
    authSave.savetime = getCurrentDateTime();
    authSave.id = authSave.savetime;
    await ORMContext.em.persistAndFlush(authSave);

    save.credits = authSave.credits;
    save.resources = authSave.resources;
    save.outposts = authSave.outposts;
    save.buildingresources = authSave.buildingresources;
  }

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
