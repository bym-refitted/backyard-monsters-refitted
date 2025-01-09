import { FieldData, Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { KoaController } from "../../../utils/KoaController";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { logging } from "../../../utils/logger";
import { Status } from "../../../enums/StatusCodes";
import { SaveKeys } from "../../../enums/SaveKeys";
import { BaseSaveSchema } from "./zod/BaseSaveSchema";
import { resourcesHandler } from "./handlers/resourceHandler";
import { purchaseHandler } from "./handlers/purchaseHandler";
import { academyHandler } from "./handlers/academyHandler";
import { mapUserSaveData } from "../mapUserSaveData";
import { BaseType } from "../../../enums/Base";
import { saveFailureErr } from "../../../errors/errors";
import { attackLootHandler } from "./handlers/attackLootHandler";
import { monsterUpdateHandler } from "./handlers/monsterUpdateHandler";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const userSave = user.save;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);

    const baseSave = await ORMContext.em.findOne(Save, {
      basesaveid: saveData.basesaveid,
    });

    if (!baseSave) throw saveFailureErr();

    const isOwner = baseSave.saveuserid === user.userid;
    const isOutpost = isOwner && baseSave.type === BaseType.OUTPOST;

    // Standard save logic
    for (const key of Save.saveKeys) {
      const value = ctx.request.body[key];

      switch (key) {
        case SaveKeys.RESOURCES:
          resourcesHandler(ctx, userSave, baseSave, isOutpost);
          break;

        case SaveKeys.PURCHASE:
          purchaseHandler(saveData.purchase, userSave, baseSave);
          break;

        case SaveKeys.ACADEMY:
          academyHandler(ctx, baseSave);
          break;

        case SaveKeys.BUILDING_HEALTH_DATA:
          if (value) baseSave.buildinghealthdata = saveData.buildinghealthdata;
          break;

        case SaveKeys.CHAMPION:
          if (value) baseSave.champion = saveData.champion;
          break;

        default:
          if (value) {
            try {
              baseSave[key] = JSON.parse(value);
            } catch (_) {
              baseSave[key] = value;
            }
          }
      }

      if (isOutpost) updateOutposts(userSave, baseSave, key);
    }

    // Attack save logic
    const isAttack =
      baseSave.attackid !== 0 && baseSave.saveuserid !== user.userid;

    if (isAttack) {
      for (const key of Object.keys(saveData)) {
        const value = saveData[key];

        switch (key) {
          case SaveKeys.ATTACKERCHAMPION:
            if (value) userSave.attackerchampion = value;
            break;

          case SaveKeys.MONSTERUPDATE:
            await monsterUpdateHandler(value, userSave);
            break;

          case SaveKeys.ATTACKLOOT:
            attackLootHandler(value, userSave);
            break;

          default:
            break;
        }
      }
      await ORMContext.em.persistAndFlush(userSave);
    }

    baseSave.attackid = saveData.over ? 0 : baseSave.attackid;
    // if (over) save.protected = isNaN(destroyed) ? 0 : destroyed;

    baseSave.id = baseSave.savetime;
    baseSave.savetime = getCurrentDateTime();
    await ORMContext.em.persistAndFlush(baseSave);

    const filteredSave = FilterFrontendKeys(baseSave);

    logging(
      `Saving ${user.username}'s base | basesaveid: ${saveData.basesaveid}`
    );

    const responseBody = {
      error: 0,
      basesaveid: baseSave.basesaveid,
      ...filteredSave,
    };

    if (user.userid === filteredSave.userid) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    logging(`Failed to save base for user: ${user.username}`, err);
    throw saveFailureErr();
  }
};

const updateOutposts = (
  userSave: Save,
  baseSave: Save,
  key: keyof FieldData
) => {
  if (key === SaveKeys.BUILDING_RESOURCES) {
    userSave.buildingresources[`b${baseSave.baseid}`] =
      baseSave.buildingresources[`b${baseSave.baseid}`];
    userSave.buildingresources["t"] = getCurrentDateTime();
  }

  if (key === SaveKeys.QUESTS) {
    userSave.quests = baseSave.quests;
  }
};
