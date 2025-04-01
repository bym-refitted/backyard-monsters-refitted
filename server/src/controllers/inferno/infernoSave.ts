import { molochTribes } from "../../data/tribes/molochTribes";
import { BaseType } from "../../enums/Base";
import { SaveKeys } from "../../enums/SaveKeys";
import { Status } from "../../enums/StatusCodes";
import { permissionErr, saveFailureErr } from "../../errors/errors";
import { ClientSafeError } from "../../middleware/clientSafeError";
import { InfernoMaproom } from "../../models/infernomaproom.model";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime";
import { KoaController } from "../../utils/KoaController";
import { errorLog } from "../../utils/logger";
import { academyHandler } from "../base/save/handlers/academyHandler";
import { buildingDataHandler } from "../base/save/handlers/buildingDataHandler";
import { purchaseHandler } from "../base/save/handlers/purchaseHandler";
import { resourcesHandler } from "../base/save/handlers/resourceHandler";
import { BaseSaveSchema } from "../base/save/zod/BaseSaveSchema";

export const infernoSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const userSave = user.save;
  const userInfernoSave = user.infernoSave;
  await ORMContext.em.populate(user, ["save", "infernoSave"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);
    const currentSave: Save = userInfernoSave || userSave;
    let tribeSave: Save = null;

    const { basesaveid } = saveData;
    let baseSave = await ORMContext.em.findOne(Save, { basesaveid });

    // Retrieve a moloch tribe when no base save is found
    // Tribe save logic
    if (!baseSave) {
      const maproom1 = await ORMContext.em.findOne(InfernoMaproom, {
        userid: user.userid,
      });

      let existingTribe = maproom1.tribedata.find(
        (tribe) => tribe.baseid === saveData.baseid
      );

      if (!existingTribe) throw saveFailureErr();

      // Update the existing tribe's health data
      existingTribe.tribeHealthData = saveData.buildinghealthdata;

      // Update the wild monster status on the user save
      currentSave.wmstatus.forEach((tribe) => {
        if (tribe[0] === Number(saveData.baseid)) tribe[2] = saveData.destroyed;
      });

      const tribeData = molochTribes.find(
        (tribe) => tribe.baseid === saveData.baseid
      );

      tribeSave = Object.assign(new Save(), {
        ...tribeData,
        baseid: saveData.baseid,
        buildinghealthdata: existingTribe?.tribeHealthData || {},
      });

      await ORMContext.em.persistAndFlush(maproom1);

      for (const key of Object.keys(saveData)) {
        const value = saveData[key];

        switch (key) {
          case SaveKeys.ATTACKCREATURES:
            currentSave.monsters = value;
            break;

          case SaveKeys.ATTACKERCHAMPION:
            userSave.champion = saveData.attackerchampion;
            break;

          case SaveKeys.ATTACKLOOT:
            if (userInfernoSave) 
              resourcesHandler(userSave, value, SaveKeys.IRESOURCES);
            break;
        }
      }
      await ORMContext.em.persistAndFlush(userSave);
    }

    // Standard save logic for user or attacking another user
    if (baseSave) {
      const isOwner = baseSave.saveuserid === user.userid;
      const isAttack = !isOwner && baseSave.attackid !== 0;

      if (!isOwner && baseSave.attackid === 0) throw permissionErr();

      for (const key of isAttack ? Save.attackSaveKeys : Save.saveKeys) {
        const value = ctx.request.body[key];

        switch (key) {
          case SaveKeys.RESOURCES:
            resourcesHandler(baseSave, value);
            userSave.iresources = baseSave.resources;
            break;

          case SaveKeys.PURCHASE:
            purchaseHandler(ctx, saveData.purchase, baseSave);
            break;

          case SaveKeys.ACADEMY:
            academyHandler(ctx, baseSave);
            break;

          case SaveKeys.BUILDINGDATA:
            if (isAttack) {
              buildingDataHandler(saveData.buildingdata, baseSave);
            } else {
              baseSave[SaveKeys.BUILDINGDATA] = saveData.buildingdata;
            }

          default:
            if (value) {
              try {
                baseSave[key] = JSON.parse(value);
              } catch (_) {
                baseSave[key] = value;
              }
            }
        }
      }

      baseSave.id = baseSave.savetime;
      baseSave.savetime = getCurrentDateTime();
      await ORMContext.em.persistAndFlush(baseSave);
    }

    const filteredSave = FilterFrontendKeys(tribeSave ?? baseSave);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      ...filteredSave,
      credits: userSave.credits,
    };
  } catch (err) {
    errorLog(`Failed to save inferno base for user: ${user.username}`, err);

    if (err instanceof ClientSafeError) throw err;
    throw new Error("An unexpected error occurred while saving this base.");
  }
};
