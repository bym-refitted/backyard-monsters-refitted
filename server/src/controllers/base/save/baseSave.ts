import { FieldData, Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { KoaController } from "../../../utils/KoaController";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { errorLog, logging } from "../../../utils/logger";
import { Status } from "../../../enums/StatusCodes";
import { SaveKeys } from "../../../enums/SaveKeys";
import { BaseSaveSchema } from "./zod/BaseSaveSchema";
import { resourcesHandler } from "./handlers/resourceHandler";
import { purchaseHandler } from "./handlers/purchaseHandler";
import { academyHandler } from "./handlers/academyHandler";
import { mapUserSaveData } from "../mapUserSaveData";
import { BaseType } from "../../../enums/Base";
import { permissionErr, saveFailureErr } from "../../../errors/errors";
import { attackLootHandler } from "./handlers/attackLootHandler";
import { monsterUpdateHandler } from "./handlers/monsterUpdateHandler";
import { ClientSafeError } from "../../../middleware/clientSafeError";
import { championHandler } from "./handlers/championHandler";
import { anticheat } from "../../../scripts/anticheat/anticheat";

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
  await ORMContext.em.populate(user, ["save"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);

    const baseSave = await ORMContext.em.findOne(Save, {
      basesaveid: saveData.basesaveid,
    });

    if (!baseSave) throw saveFailureErr();

    const isOwner = baseSave.saveuserid === user.userid;
    const isOutpostOwner = isOwner && baseSave.type === BaseType.OUTPOST;
    const isAttack = !isOwner && baseSave.attackid !== 0;

    // Not the owner and not in an attack
    if (!isOwner && baseSave.attackid === 0) throw permissionErr();

    await anticheat(ctx, async () => {});

    // Standard save logic
    for (const key of isAttack ? Save.attackSaveKeys : Save.saveKeys) {
      const value = ctx.request.body[key];

      switch (key) {
        case SaveKeys.RESOURCES:
          resourcesHandler(ctx, userSave, baseSave, isOutpostOwner);
          break;

        case SaveKeys.PURCHASE:
          purchaseHandler(saveData.purchase, userSave, baseSave);
          break;

        case SaveKeys.ACADEMY:
          academyHandler(ctx, baseSave);
          break;

        case SaveKeys.CHAMPION:
          if (isAttack) {
            championHandler(saveData.attackerchampion, userSave);
          } else {
            baseSave[SaveKeys.CHAMPION] = saveData.champion;
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
        // These keys are used for calculations on the server to update other fields
        // but should not be persisted to the database (Remove in the future).
        // Figure out what they are used for.
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
      await ORMContext.em.persistAndFlush(userSave);
    }

    // Set the attackid to 0 if the attack is over
    baseSave.attackid = saveData.over ? 0 : baseSave.attackid;
    //if (over) save.protected = isNaN(destroyed) ? 0 : destroyed;

    baseSave.id = baseSave.savetime;
    baseSave.savetime = getCurrentDateTime();
    await ORMContext.em.persistAndFlush(baseSave);

    const filteredSave = FilterFrontendKeys(baseSave);
    logging(`Saving ${user.username}'s base`);

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
    errorLog(`Failed to save base for user: ${user.username}`, err);

    if (err instanceof ClientSafeError) throw err;
    throw new Error("An unexpected error occurred while saving this base.");
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
