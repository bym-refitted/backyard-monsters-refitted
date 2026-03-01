import { devConfig } from "../../../config/DevSettings.js";
import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { storeItems } from "../../../data/store/storeItems.js";
import { User } from "../../../models/user.model.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import { getFlags } from "../../../data/flags.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { BaseMode, BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { WORLD_SIZE } from "../../../config/MapRoom2Config.js";
import { RESOURCE_PRODUCTION_RATES, RESOURCE_CAPACITIES } from "../../../config/MapRoom3Config.js";
import { Status } from "../../../enums/StatusCodes.js";
import { baseModeView } from "./modes/baseModeView.js";
import { baseModeBuild } from "./modes/baseModeBuild.js";
import { logger } from "../../../utils/logger.js";
import { baseModeAttack } from "./modes/baseModeAttack.js";
import { mapUserSaveData } from "../mapUserSaveData.js";
import { infernoModeDescent } from "./modes/infernoModeDescent.js";
import { infernoModeView } from "./modes/infernoModeView.js";
import { infernoModeAttack } from "./modes/infernoModeAttack.js";
import { infernoModeBuild } from "./modes/infernoModeBuild.js";
import { validateAttack } from "../../../services/maproom/validateAttack.js";
import { BaseLoadSchema } from "../../../zod/BaseLoadSchema.js";
import { discordAgeErr } from "../../../errors/errors.js";

/**
 * Controller responsible for loading base modes based on the user's request.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base load process is complete.
 * @throws Will throw an error if the base load process fails.
 */
export const baseLoad: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save", "infernosave"]);

  try {
    const worldid = user.save?.worldid;
    const { baseid, type, mapversion, attackData } = BaseLoadSchema.parse(ctx.request.body);

    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(user, baseid);
        break;

      case BaseMode.VIEW:
      case BaseMode.IVIEW:
        baseSave = await baseModeView(baseid, mapversion, worldid);
        break;

      case BaseMode.ATTACK:
        if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

        await validateAttack(user, attackData, mapversion);
        baseSave = await baseModeAttack(user, baseid, mapversion);
        break;

      case BaseMode.IDESCENT:
        baseSave = await infernoModeDescent(user);
        break;

      case BaseMode.IBUILD:
        baseSave = await infernoModeBuild(user);
        break;

      case BaseMode.IWMVIEW:
        baseSave = await infernoModeView(user, baseid);
        break;

      case BaseMode.IATTACK:
        if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

        await validateAttack(user, attackData);
        baseSave = await infernoModeAttack(user, baseid);
        break;

      case BaseMode.IWMATTACK:
        await validateAttack(user, attackData);
        baseSave = await infernoModeAttack(user, baseid);
        break;
        
      default:
        throw new Error(`Base type not handled, type: ${type}.`);
    }

    const filteredSave = FilterFrontendKeys(baseSave);
    const isTutorialEnabled = devConfig.skipTutorial ? 205 : filteredSave.tutorialstage;

    const flags = getFlags();
    flags.discordOldEnough = ctx.meetsDiscordAgeCheck;

    const isOwner = baseSave.type !== BaseType.INFERNO && user.userid === filteredSave.userid;
    
    let totalResourceRate = 0;
    let totalResourceCapacity = 0;

    // Sum production rate and storage capacity from all player-owned MR3 resource outposts.
    if (isOwner && mapversion === MapRoomVersion.V3) {
      const resourceOutposts = await postgres.em.find(Save, {
        saveuserid: user.userid,
        type: BaseType.OUTPOST,
        wmid: EnumYardType.RESOURCE,
      });

      for (const { level } of resourceOutposts) {
        totalResourceRate += RESOURCE_PRODUCTION_RATES[level];
        totalResourceCapacity += RESOURCE_CAPACITIES[level];
      }
    }

    ctx.status = Status.OK;
    ctx.body = {
      ...filteredSave,
      canattack: true,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      champion: JSON.stringify(filteredSave.champion),
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      currenttime: getCurrentDateTime(),
      pic_square: `${process.env.AVATAR_URL}?seed=${filteredSave.name}&size=${50}`,
      ...(isOwner && mapUserSaveData(user)),
      ...(isOwner && mapversion === MapRoomVersion.V3 && {
        player: { buffs: { 2: totalResourceRate, 10: totalResourceCapacity } },
      }),
    };
  } catch (err) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "The server failed to load this base." };
    logger.error(`Failed to load base`, err);
  }
};
