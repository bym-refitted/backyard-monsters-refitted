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
import { auth } from "../middleware/auth";

export const baseSave: KoaController = async (ctx) => {
  
  const descentBases: number[] = [201,202,203,204,205,206,207];
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"])
  const authSave = user.save;
  const basesaveid = ctx.request.body["basesaveid"]
  logging(`Saving user's base: ${user.username} | IP Address: ${ctx.ip} | Base ID: ${basesaveid}`);

  if (!basesaveid) throw saveFailureErr

  const save = await ORMContext.em.findOne(Save, {
    basesaveid: parseInt(basesaveid)
  })

  if (!save) {
    /* Before, if there is no save, we threw an error.
      Now, we check if the ID matches a descent base 
    */
    if (descentBases.includes(parseInt(basesaveid))) {
      //logging("is Destroyed?: " + ctx.request.body["destroyed"]);
      try {
        if (parseInt(ctx.request.body["destroyed"]) === 1) {
          let baseIndex = descentBases.indexOf(parseInt(basesaveid));
          let userDescentBases = await ORMContext.em.findOne(DescentStatus, {
            userid: authSave.userid,
          });
          if (userDescentBases) {
            // find the corresponding WM status descent base
            let stored_base = userDescentBases.wmstatus[baseIndex];
            // set it to be destroyed
            stored_base[2] = 1;
            // insert back into database
            userDescentBases[baseIndex] = stored_base;

            await ORMContext.em.persistAndFlush(userDescentBases);
          }

          let iloot = JSON.parse(ctx.request.body["lootreport"]);
          logging(iloot);
          logging(iloot["r1"])

          let lootIResources: Resources = {
            r1: iloot["r1"],
            r2: iloot["r2"],
            r3: iloot["r3"],
            r4: iloot["r4"],
          }
          const savedLootIResources: FieldData = updateResources(
            lootIResources,
            authSave.iresources || {}
          );
          authSave.iresources = savedLootIResources;
          ORMContext.em.persistAndFlush(authSave);
        }
        
        // send 200 status so the game doesn't kill itself 
        ctx.status = 200;
        ctx.body = {
          error: 0
        }
      } catch (error) {
        logging(error);
      }
    } else {
      throw saveFailureErr;
    }
  } 
  else {
    const isOutpost = save.saveuserid === user.userid && save.homebaseid != save.basesaveid;
    const isInferno = save.type === "inferno"

    logging(isInferno + "");

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
          let sr;
          if (!isInferno) {
            sr = isOutpost ? authSave.resources : save.resources;
          } else {
            sr = save.resources;
          }
          const savedResources: FieldData = updateResources(
            resources,
            sr || {}
          );
          save.resources = savedResources;
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

    if (isOutpost && !isInferno) {
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
  }
};
