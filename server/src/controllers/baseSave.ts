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
import { ProcessDescentBase, descentBases } from "../services/inferno/processDescentBase";

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

  if (!save) {
    /* Before, if there is no save, we threw an error.
      Now, we check if the ID matches a descent base 
    */
    if (descentBases.includes(parseInt(basesaveid)) || descentBases.includes(parseInt(JSON.parse(ctx.request.body["baseid"])))) {
      //logging("is Destroyed?: " + ctx.request.body["destroyed"]);
      let descentData = await ProcessDescentBase(ctx, 
        parseInt(basesaveid), 
        ctx.request.body["baseid"], 
        authSave.userid, 
        authSave.iresources
      );
      authSave.iresources = descentData[0];
      authSave.champion = descentData[1];
      authSave.monsters = descentData[2];
      await ORMContext.em.persistAndFlush(authSave);
      // send 200 status so the game doesn't kill itself 
      ctx.status = 200;
      ctx.body = {
        error: 0
      }
    } else {
      throw saveFailureErr;
    }
  } 
  else {
    const isOutpost = save.saveuserid === user.userid && save.homebaseid != save.basesaveid;
    const isInferno = save.type === "inferno"

    if (!isInferno && ctx.request.body.hasOwnProperty("iresources"))
    {
      logging("Main Yard:" + save.baseid + " wants to use inferno resources");
      const iResources: Resources = JSON.parse(ctx.request.body["iresources"]);
      // Save iresources -> inferno.resources
      let infSave: Save = await ORMContext.em.findOne(Save, {
        type: "inferno",
        saveuserid: authSave.saveuserid
      });

      if (infSave) {
        logging("Using resources from Inferno Yard: " + infSave.baseid);
        const savedIResources: FieldData = updateResources(
          iResources,
          authSave.iresources
        );

        logging ("Saving updated resources: " + JSON.stringify(savedIResources) + " to main and inferno yards.")

        save.iresources = savedIResources;

        infSave.resources = savedIResources;
        await ORMContext.em.persistAndFlush(infSave);
      }
    }

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
          if (isInferno) authSave.iresources = savedResources;
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
            if (!isInferno) {
              updateCredits(isOutpost ? authSave : save, item, quantity);
            }
            else {
              updateCredits(save, item, quantity);
              updateCredits(authSave, item, quantity);
            }
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
          if (isInferno) authSave.academy = academyData;
          break;
        case "lockerdata":
          let lockerData = JSON.parse(requestBodyValue);
          save.lockerdata = lockerData;
          if (isInferno) {
            authSave.lockerdata = lockerData;
          }
          break;
        default:
          if (
            requestBodyValue &&
            !Array.isArray(requestBodyValue) &&
            requestBodyValue !== undefined &&
            key !== "iresources"
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

      if (ctx.request.body.hasOwnProperty("attackcreatures")) {
        logging(ctx.request.body["attackcreatures"]);
        authSave.monsters = JSON.parse(ctx.request.body["attackcreatures"]);
      }

      // Same as with saving Champion data, we save siege data
      if (ctx.request.body.hasOwnProperty("attackersiege")) {
        authSave.siege = JSON.parse(ctx.request.body["attackersiege"]);
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
