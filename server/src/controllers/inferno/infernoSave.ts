import { SaveKeys } from "../../enums/SaveKeys";
import { Status } from "../../enums/StatusCodes";
import { permissionErr } from "../../errors/errors";
import { ClientSafeError } from "../../middleware/clientSafeError";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { scaledTribes } from "../../services/maproom/v1/scaledTribes";
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
  await ORMContext.em.populate(user, ["save", "infernosave"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);

    // Fist attempt to find a user's Inferno base save
    const { basesaveid } = saveData;
    let baseSave = await ORMContext.em.findOne(Save, { basesaveid });

    // Otherwise, retrieve a moloch tribe and handle tribe save logic
    if (!baseSave) {
      const tribeSave = await scaledTribes(user, saveData);
      const filteredSave = FilterFrontendKeys(tribeSave);

      ctx.status = Status.OK;
      ctx.body = {
        error: 0,
        ...filteredSave,
      };
      return;
    }

    // Standard save logic for user or attacking another user
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

    const filteredSave = FilterFrontendKeys(baseSave);

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
