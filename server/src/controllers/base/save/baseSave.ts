import { FieldData, Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { KoaController } from "../../../utils/KoaController";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { errorLog, logging } from "../../../utils/logger";
import { updateMonsters } from "../../../services/base/updateMonsters";
import { Status } from "../../../enums/StatusCodes";
import { SaveKeys } from "../../../enums/SaveKeys";
import { BaseSaveSchema } from "./zod/BaseSaveSchema";
import { resourcesHandler } from "./handlers/resourceHandler";
import { purchaseHandler } from "./handlers/purchaseHandler";
import { academyHandler } from "./handlers/academyHandler";
import { buildingResourcesHandler } from "./handlers/buildResourcesHandler";
import {
  Resources,
  updateResources,
} from "../../../services/base/updateResources";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const { basesaveid, buildinghealthdata, champion } = BaseSaveSchema.parse(
      ctx.request.body
    );
    const userSave = user.save;

    const save = await ORMContext.em.findOne(Save, { basesaveid });

    if (!save) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      errorLog(`Base save not found for baseid: ${basesaveid}`);
    }

    const isOutpost = save.saveuserid === user.userid && save.homebaseid != save.basesaveid;

    // Update the save with the values from the request
    // Some keys require special handling, so we have separate handlers for them
    for (const key of Save.jsonKeys) {
      const saveData = ctx.request.body[key];

      switch (key) {
        case SaveKeys.RESOURCES:
          resourcesHandler(ctx, userSave, save, isOutpost);
          break;

        case SaveKeys.PURCHASE:
          purchaseHandler(ctx, userSave, save);
          break;

        case SaveKeys.ACADEMY:
          academyHandler(ctx, save);
          break;

        case SaveKeys.BUILDING_RESOURCES:
          buildingResourcesHandler(save, userSave, isOutpost);
          break;

        case SaveKeys.BUILDING_HEALTH_DATA:
          if (saveData) save.buildinghealthdata = buildinghealthdata;
          break;

        case SaveKeys.CHAMPION:
          if (saveData) save.champion = champion;
          break;
        default:
          // Default case is to parse the JSON string if it's not an array
          if (saveData && !Array.isArray(saveData))
            save[key] = JSON.parse(saveData);
      }
    }

    // ==================================== //
    // ATTACK MODE
    // ==================================== //
    // What is this?
    for (const key in <any>ctx.request.body) {
      if (Save.nonJsonKeys.includes(key) && !Save.jsonKeys.includes(key)) {
        if (ctx.request.body[key] !== null) {
          let data = ctx.request.body[key];
          save[key] = data;
        }
      }
    }

    if (
      save.basesaveid !== userSave.basesaveid &&
      save.attackid != 0 &&
      save.saveuserid !== user.userid
    ) {
      if (ctx.request.body.hasOwnProperty("attackerchampion")) {
        userSave.champion = ctx.request.body["attackerchampion"];
      }
      if (save.monsterupdate.length > 0) {
        const authMonsters = save.monsterupdate.find(
          ({ baseid }) => baseid == userSave.baseid
        );
        const monsterUpdates = save.monsterupdate.filter(
          ({ baseid }) => baseid != userSave.baseid
        );
        if (authMonsters) {
          userSave.monsters = authMonsters.m;
        }
        if (monsterUpdates.length > 0) {
          await updateMonsters(monsterUpdates);
        }
      }
      const resources = <Resources>save.attackloot;
      const savedResources: FieldData = updateResources(
        resources,
        userSave.resources || {}
      );
      userSave.resources = savedResources;
      await ORMContext.em.persistAndFlush(userSave);
    }

    save.attackid = ctx.request.body["over"] ? 0 : save.attackid;
    if (ctx.request.body.hasOwnProperty("over")) {
      save.protected = ctx.request.body["destroyed"];
    }

    save.savetime = getCurrentDateTime();
    save.id = save.savetime;

    await ORMContext.em.persistAndFlush(save);

    if (isOutpost) {
      userSave.savetime = getCurrentDateTime();
      userSave.id = userSave.savetime;
      await ORMContext.em.persistAndFlush(userSave);

      save.credits = userSave.credits;
      save.resources = userSave.resources;
      save.outposts = userSave.outposts;
      save.buildingresources = userSave.buildingresources;
    }

    logging(`Saving ${user.username}'s base | basesaveid: ${basesaveid}`);

    const filteredSave = FilterFrontendKeys(save);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      basesaveid: save.basesaveid,
      ...filteredSave,
    };
  } catch (err) {
    logging(`Failed to save base for user: ${user.username}`, err);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
  }
};
