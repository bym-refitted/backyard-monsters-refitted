import type { KoaController } from "../../../utils/KoaController.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres, redis } from "../../../server.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { logger } from "../../../utils/logger.js";
import { Status } from "../../../enums/StatusCodes.js";
import { SaveKeys } from "../../../enums/SaveKeys.js";
import { BaseSaveSchema } from "../../../schemas/BaseSaveSchema.js";
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
import { takeoverCellMR3, type TakeoverData } from "../../../services/maproom/v3/takeoverCellMR3.js";
import { damageProtection } from "../../../services/maproom/v2/damageProtection.js";
import { isMR3Structure } from "../../../services/maproom/v3/utils/isMR3Structure.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { MR1_TRIBE_IDS } from "../../../game-data/tribes/v1/index.js";
import { scaledMR1Tribes } from "../../../services/maproom/v1/scaledMR1Tribes.js";

/**
 * Controller responsible for saving the user's base data.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base save process is complete.
 * @throws Will throw an error if the save operation fails.
 */
export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const userSave = user.save!;

  const body = ctx.request.body as Record<string, unknown>;
  const saveData = BaseSaveSchema.parse(body);

  const { basesaveid } = saveData;
  const baseSave = await postgres.em.findOne(Save, { basesaveid });

  if (!baseSave && MR1_TRIBE_IDS.has(saveData.baseid)) {
    const tribeSave = await scaledMR1Tribes(user, saveData);
    const filteredSave = FilterFrontendKeys(tribeSave);

    ctx.status = Status.OK;
    ctx.body = { error: 0, ...filteredSave };
    return;
  }

  if (!baseSave) throw saveFailureErr();

  const isOwner = baseSave.saveuserid === user.userid;
  const isOutpostOwner = isOwner && baseSave.type === BaseType.OUTPOST;
  const isAttack = !isOwner && baseSave.attackid !== 0;

  // Not the owner and not in an attack
  if (!isOwner && baseSave.attackid === 0) throw permissionErr();

  await validateSave(user, baseSave, body);

  // Standard save logic
  for (const key of isAttack ? Save.attackSaveKeys : Save.saveKeys) {
    const value = body[key] as string;

    switch (key) {
      case SaveKeys.RESOURCES:
        resourcesHandler(baseSave, value);
        if (isOutpostOwner) {
          const resources = JSON.parse(value);
          userSave.resources = updateResources(resources, userSave.resources!);
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

      case SaveKeys.ACADEMY:
        academyHandler(ctx, baseSave);
        break;

      case SaveKeys.BUILDINGDATA:
        if (saveData.buildingdata == null) break;

        if (isAttack) {
          buildingDataHandler(saveData.buildingdata, baseSave);
        } else {
          baseSave[SaveKeys.BUILDINGDATA] = saveData.buildingdata;
        }
        break;

      case SaveKeys.CHAMPION:
        if (isAttack) {
          if (saveData.attackerchampion) {
            userSave.champion = saveData.attackerchampion;
          }
        } else {
          if (saveData.champion) {
            baseSave.champion = saveData.champion;
          }
        }
        break;

      case SaveKeys.ATTACKERSIEGE:
        if (isAttack) {
          userSave.siege = saveData.attackersiege;
        }
        break;

      default:
        if (value) {
          const save = baseSave as unknown as Record<string, unknown>;
          try {
            save[key] = JSON.parse(value);
          } catch (_) {
            save[key] = value;
          }
        }
    }

    if (isOutpostOwner) updateOutposts(userSave, baseSave, key);
  }

  if (!isAttack && saveData.purchase) purchaseHandler(ctx, saveData.purchase, userSave);

  let takeoverData: TakeoverData | null = null;

  if (isAttack) {
    if (saveData.monsterupdate) {
      await monsterUpdateHandler(saveData.monsterupdate, userSave);
    }

    if (saveData.attackcreatures) {
      userSave.monsters = saveData.attackcreatures;
    }

    if (saveData.attackloot) {
      attackLootHandler(saveData.attackloot, userSave);
    }

    postgres.em.persist(userSave);
    await postgres.em.flush();

    // MR3 Takeover Logic:
    // If the attack is over and damage >= 90, trigger takeover or destroy logic.
    // MR3 capturable structures (RESOURCE, STRONGHOLD, FORTIFICATION) allow re-capture
    // from OUTPOST type (player-owned) in addition to first capture from TRIBE type.
    if (saveData.over && baseSave.damage >= 90) {
      if (isMR3Structure(baseSave.wmid)) {
        if (baseSave.type === BaseType.TRIBE || baseSave.type === BaseType.OUTPOST) {
          takeoverData = await takeoverCellMR3(baseSave, user, userSave);
        }
      } else if (baseSave.type === BaseType.TRIBE) {
        const cell = await postgres.em.findOne(WorldMapCell, {
          baseid: baseSave.baseid,
          map_version: MapRoomVersion.V3,
        });

        if (cell && !cell.destroyed_at) cell.destroyed_at = new Date();
      }
    }
    // Grant damage protection to the defender main yard when the attack ends.
    const isProtectable = baseSave.type === BaseType.MAIN || baseSave.type === BaseType.OUTPOST;

    if (saveData.over && isProtectable && !isMR3Structure(baseSave.wmid)) {
      await damageProtection(baseSave);
    }
  }

  baseSave.attackid = saveData.over ? 0 : baseSave.attackid;

  baseSave.id = baseSave.savetime;
  baseSave.savetime = getCurrentDateTime();

  if (!isAttack) {
    await redis.setex(`last-seen:main:${user.userid}`, 120, getCurrentDateTime().toString());
  }

  postgres.em.persist(baseSave);
  await postgres.em.flush();

  const filteredSave = FilterFrontendKeys(baseSave);
  logger.info(`Saving ${user.username}'s base | IP: ${ctx.ip}`);

  const responseBody = {
    error: 0,
    basesaveid: baseSave.basesaveid,
    ...filteredSave,
    ...(takeoverData && { takeover: takeoverData }),
  };

  if (user.userid === filteredSave.userid) {
    Object.assign(responseBody, mapUserSaveData(user));
  }

  ctx.status = Status.OK;
  ctx.body = responseBody;
};

const updateOutposts = (
  userSave: Save,
  baseSave: Save,
  key: keyof Save
) => {
  if (key === SaveKeys.BUILDING_RESOURCES && userSave.buildingresources) {
    userSave.buildingresources[`b${baseSave.baseid}`] = baseSave.buildingresources?.[`b${baseSave.baseid}`];
    userSave.buildingresources["t"] = getCurrentDateTime();
  }

  if (key === SaveKeys.QUESTS) {
    userSave.quests = baseSave.quests;
  }
};
