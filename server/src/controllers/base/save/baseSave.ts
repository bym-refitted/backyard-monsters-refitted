import { type FieldData, Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { logger } from "../../../utils/logger.js";
import { Status } from "../../../enums/StatusCodes.js";
import { SaveKeys } from "../../../enums/SaveKeys.js";
import { BaseSaveSchema } from "../../../zod/BaseSaveSchema.js";
import { resourcesHandler } from "./handlers/resourceHandler.js";
import { purchaseHandler } from "./handlers/purchaseHandler.js";
import { academyHandler } from "./handlers/academyHandler.js";
import { mapUserSaveData } from "../mapUserSaveData.js";
import { BaseType } from "../../../enums/Base.js";
import { permissionErr, saveFailureErr } from "../../../errors/errors.js";
import { attackLootHandler } from "./handlers/attackLootHandler.js";
import { monsterUpdateHandler } from "./handlers/monsterUpdateHandler.js";
import { validateSave } from "../../../scripts/anticheat/anticheat.js";
import { updateResources } from "../../../services/base/updateResources.js";
import { buildingDataHandler } from "./handlers/buildingDataHandler.js";

/**
 * Controller responsible for saving the user's base data.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base save process is complete.
 * @throws Will throw an error if the save operation fails.
 */
export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const userSave = user.save;
  await postgres.em.populate(user, ["save"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);

    const { basesaveid } = saveData;
    const baseSave = await postgres.em.findOne(Save, { basesaveid });

    if (!baseSave) throw saveFailureErr();

    const isOwner = baseSave.saveuserid === user.userid;
    const isOutpostOwner = isOwner && baseSave.type === BaseType.OUTPOST;
    const isAttack = !isOwner && baseSave.attackid !== 0;

    // Not the owner and not in an attack
    if (!isOwner && baseSave.attackid === 0) throw permissionErr();

    await validateSave(user, baseSave, ctx.request.body);

    // Standard save logic
    for (const key of isAttack ? Save.attackSaveKeys : Save.saveKeys) {
      const value = ctx.request.body[key];

      switch (key) {
        case SaveKeys.RESOURCES:
          resourcesHandler(baseSave, value);
          if (isOutpostOwner) {
            const resources = JSON.parse(value);
            userSave.resources = updateResources(resources, userSave.resources);
          }
          break;

        case SaveKeys.POINTS:
          baseSave.points = value.toString();
          break;

        case SaveKeys.BASEVALUE:
          baseSave.basevalue = value.toString();
          break;

        case SaveKeys.IRESOURCES:
          resourcesHandler(baseSave, value, SaveKeys.IRESOURCES);
          break;

        case SaveKeys.PURCHASE:
          purchaseHandler(ctx, saveData.purchase, userSave);
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

        case SaveKeys.CHAMPION:
          if (isAttack) {
            userSave[SaveKeys.CHAMPION] = saveData.attackerchampion;
          } else {
            baseSave[SaveKeys.CHAMPION] = saveData.champion;
          }
          break;

        case SaveKeys.ATTACKERSIEGE:
          if (isAttack) {
            userSave.siege = saveData.attackersiege;
          }
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

      if (isOutpostOwner) updateOutposts(userSave, baseSave, key);
    }

    if (isAttack) {
      for (const key of Object.keys(saveData)) {
        const value = saveData[key];
        switch (key) {
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
      await postgres.em.persistAndFlush(userSave);
    }

    // Set the attackid to 0 if the attack is over
    baseSave.attackid = saveData.over ? 0 : baseSave.attackid;
    //if (over) save.protected = isNaN(destroyed) ? 0 : destroyed;

    baseSave.id = baseSave.savetime;
    baseSave.savetime = getCurrentDateTime();
    await postgres.em.persistAndFlush(baseSave);

    const filteredSave = FilterFrontendKeys(baseSave);
    logger.info(`Saving ${user.username}'s base | IP: ${ctx.ip}`);

    const responseBody = {
      error: 0,
      basesaveid: baseSave.basesaveid,
      ...filteredSave,
      champion: JSON.stringify(filteredSave.champion),
    };

    if (user.userid === filteredSave.userid) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    if (err instanceof Error && 'isClientFriendly' in err) {
      throw err;
    }

    logger.error(`Failed to save base for user: ${user.username}`, err);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: `Failed to save for user: ${user.username}` };
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
