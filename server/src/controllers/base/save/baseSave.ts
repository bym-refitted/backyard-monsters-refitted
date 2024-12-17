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
import {
  Resources,
  updateResources,
} from "../../../services/base/updateResources";
import { mapUserSaveData } from "../mapUserSaveData";
import { discordNotOldEnough } from "../../../errors/errors";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const {
      basesaveid,
      purchase,
      buildinghealthdata,
      champion,
      attackerchampion,
      monsterupdate,
      attackloot,
      over,
      attackid,
    } = BaseSaveSchema.parse(ctx.request.body);

    const userSave = user.save;

    const save = await ORMContext.em.findOne(Save, { basesaveid });

    if (!save) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      errorLog(`Base save not found for baseid: ${basesaveid}`);
      return;
    }

    const isOwner = save.saveuserid === user.userid;
    const isOutpost = isOwner && save.homebaseid !== save.basesaveid;

    // Validate that the user is the owner of the base or it is an attack
    if (!isOwner && !attackid) {
      ctx.status = Status.FORBIDDEN;
      ctx.body = {
        error: 1,
        message: "You do not have permission to access this base.",
      };
      errorLog(
        `Unauthorized access attempt by user: ${user.userid} to base: ${basesaveid}`
      );
      return;
    }

    // Update the save with the values from the request
    // Some keys require special handling, so we have separate handlers for them
    for (const key of Save.saveKeys) {
      const saveDataKey = ctx.request.body[key];

      switch (key) {
        case SaveKeys.RESOURCES:
          resourcesHandler(ctx, userSave, save, isOutpost);
          break;

        case SaveKeys.PURCHASE:
          purchaseHandler(purchase, userSave, save);
          break;

        case SaveKeys.ACADEMY:
          academyHandler(ctx, save);
          break;

        case SaveKeys.BUILDING_HEALTH_DATA:
          if (saveDataKey) save.buildinghealthdata = buildinghealthdata;
          break;

        case SaveKeys.CHAMPION:
          if (saveDataKey) save.champion = champion;
          break;
        default:
          // Default case is to parse the JSON string if it's not an array
          if (saveDataKey && !Array.isArray(saveDataKey))
            save[key] = JSON.parse(saveDataKey);
      }

      if (isOutpost) {
        if (key === SaveKeys.BUILDING_RESOURCES) {
          userSave.buildingresources[`b${save.baseid}`] =
            save.buildingresources[`b${save.baseid}`];

          userSave.buildingresources["t"] = getCurrentDateTime();
        }

        if (key === SaveKeys.QUESTS) userSave.quests = save.quests;
      }
    }

    // ==================================== //
    // ATTACK MODE
    // ==================================== //
    
    // TODO: Revisit this
    // if (!ctx.meetsDiscordAgeCheck) {
    //   console.log("Hacker attempting to attack without being old enough");
    //   throw discordNotOldEnough();
    // }
    
    const saveData = ctx.request.body as Record<string, any>;

    for (const [key, value] of Object.entries(saveData)) {
      if (Save.attackSaveKeys.includes(key) && !Save.saveKeys.includes(key)) {
        if (value !== null) {
          save[key] = value;
        }
      }
    }

    if (
      save.basesaveid !== userSave.basesaveid &&
      save.attackid != 0 &&
      save.saveuserid !== user.userid
    ) {
      if (attackerchampion) userSave.champion = attackerchampion;

      if (monsterupdate && monsterupdate.length > 0) {
        const authMonsters = monsterupdate.find(
          ({ baseid }) => baseid == userSave.baseid
        );
        const monsterUpdates = monsterupdate.filter(
          ({ baseid }) => baseid != userSave.baseid
        );
        if (authMonsters) {
          userSave.monsters = authMonsters.m;
        }
        if (monsterUpdates.length > 0) {
          await updateMonsters(monsterUpdates);
        }
      }

      if (attackloot) {
        const resources: Resources = attackloot;
        const savedResources: FieldData = updateResources(
          resources,
          userSave.resources || {}
        );
        userSave.resources = savedResources;
      }

      await ORMContext.em.persistAndFlush(userSave);
    }

    // TODO: Revisit this, likely causing issues
    save.attackid = over ? 0 : save.attackid;
    //if (over) save.protected = isNaN(destroyed) ? 0 : destroyed;

    save.savetime = getCurrentDateTime();
    save.id = save.savetime;

    await ORMContext.em.persistAndFlush(save);

    if (isOutpost) {
      await ORMContext.em.persistAndFlush(userSave);

      save.credits = userSave.credits;
      save.resources = userSave.resources;
      save.outposts = userSave.outposts;
      save.buildingresources = userSave.buildingresources;
    }
    const filteredSave = FilterFrontendKeys(save);
    logging(`Saving ${user.username}'s base | basesaveid: ${basesaveid}`);

    const responseBody = {
      error: 0,
      basesaveid: save.basesaveid,
      ...filteredSave,
    };

    if (user.userid === filteredSave.userid) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    logging(`Failed to save base for user: ${user.username}`, err);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
  }
};
