import { molochTribes } from "../../data/tribes/molochTribes";
import { BaseType } from "../../enums/Base";
import { SaveKeys } from "../../enums/SaveKeys";
import { Status } from "../../enums/StatusCodes";
import { permissionErr, saveFailureErr } from "../../errors/errors";
import { ClientSafeError } from "../../middleware/clientSafeError";
import { MapRoom1 } from "../../models/maproom1.model";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime";
import { KoaController } from "../../utils/KoaController";
import { errorLog } from "../../utils/logger";
import { academyHandler } from "../base/save/handlers/academyHandler";
import { purchaseHandler } from "../base/save/handlers/purchaseHandler";
import { resourcesHandler } from "../base/save/handlers/resourceHandler";
import { BaseSaveSchema } from "../base/save/zod/BaseSaveSchema";

export const infernoSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const userSave = user.save;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);
    let tribeSave: Save = null;

    // Attempt to find the save data for the inferno base
    let infernoSave = await ORMContext.em.findOne(Save, {
      userid: user.userid,
      type: BaseType.INFERNO,
    });

    // Otherwise, retrieve a moloch base
    if (!infernoSave) {
      console.log("No inferno save found, retrieving moloch base");
      const maproom1 = await ORMContext.em.findOne(MapRoom1, {
        userid: user.userid,
      });

      let existingTribe = maproom1.tribedata.find(
        (tribe) => tribe.baseid === saveData.baseid
      );

      if (!existingTribe) throw saveFailureErr();

      // Update the existing tribe's health data
      existingTribe.tribeHealthData = saveData.buildinghealthdata;

      // Update the wild monster status on the user save
      userSave.wmstatus.forEach((tribe) => {
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

      // Keep track of monsters & champions during an attack on a tribe
      const attackCreatures = ctx.request.body[SaveKeys.ATTACKCREATURES];
      const attackerChampion = ctx.request.body[SaveKeys.ATTACKERCHAMPION];
  
      userSave.monsters = JSON.parse(attackCreatures);

      if (attackerChampion) userSave.champion = attackerChampion;
      await ORMContext.em.persistAndFlush(userSave);
    }

    if (infernoSave) {
      const isOwner = infernoSave.saveuserid === user.userid;
      const isAttack = !isOwner && infernoSave.attackid !== 0;

      if (!isOwner && infernoSave.attackid === 0) throw permissionErr();

      for (const key of isAttack ? Save.attackSaveKeys : Save.saveKeys) {
        const value = ctx.request.body[key];

        switch (key) {
          case SaveKeys.RESOURCES:
            resourcesHandler(infernoSave, value);
            userSave.iresources = infernoSave.resources;
            break;

          case SaveKeys.PURCHASE:
            // Awful arguments, fix
            purchaseHandler(saveData.purchase, infernoSave, infernoSave);
            break;

          case SaveKeys.ACADEMY:
            academyHandler(ctx, infernoSave);
            break;

          default:
            if (value) {
              try {
                infernoSave[key] = JSON.parse(value);
              } catch (_) {
                infernoSave[key] = value;
              }
            }
        }
      }

      infernoSave.id = infernoSave.savetime;
      infernoSave.savetime = getCurrentDateTime();
      await ORMContext.em.persistAndFlush(infernoSave);
    }
    
    const filteredSave = FilterFrontendKeys(tribeSave ?? infernoSave);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      ...filteredSave,
      credits: userSave.credits
    };
  } catch (err) {
    errorLog(`Failed to save inferno base for user: ${user.username}`, err);

    if (err instanceof ClientSafeError) throw err;
    throw new Error("An unexpected error occurred while saving this base.");
  }
};
