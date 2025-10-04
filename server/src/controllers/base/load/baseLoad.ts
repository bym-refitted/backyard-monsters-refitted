import { devConfig } from "../../../config/DevSettings";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { KoaController } from "../../../utils/KoaController";
import { storeItems } from "../../../data/store/storeItems";
import { User } from "../../../models/user.model";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { getFlags } from "../../../data/flags";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { BaseMode, BaseType } from "../../../enums/Base";
import { WORLD_SIZE } from "../../../config/WorldGenSettings";
import { Status } from "../../../enums/StatusCodes";
import { baseModeView } from "./modes/baseModeView";
import { baseModeBuild } from "./modes/baseModeBuild";
import { errorLog } from "../../../utils/logger";
import { baseModeAttack } from "./modes/baseModeAttack";
import { mapUserSaveData } from "../mapUserSaveData";
import { infernoModeDescent } from "./modes/infernoModeDescent";
import { infernoModeView } from "./modes/infernoModeView";
import { infernoModeAttack } from "./modes/infernoModeAttack";
import { infernoModeBuild } from "./modes/infernoModeBuild";
import { validateAttack } from "../../../services/maproom/validateAttack";
import { BaseLoadSchema } from "../../../zod/BaseLoadSchema";
import { discordAgeErr } from "../../../errors/errors";

/**
 * Controller responsible for loading base modes based on the user's request.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base load process is complete.
 * @throws Will throw an error if the base load process fails.
 */
export const baseLoad: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save", "infernosave"]);

  try {
    const { baseid, type, attackData } = BaseLoadSchema.parse(ctx.request.body);

    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(user, baseid);
        break;

      case BaseMode.VIEW:
      case BaseMode.IVIEW:
        baseSave = await baseModeView(baseid);
        break;

      case BaseMode.ATTACK:
        if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

        await validateAttack(user, attackData);
        baseSave = await baseModeAttack(user, baseid);
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
    const isTutorialEnabled = devConfig.skipTutorial
      ? 205
      : filteredSave.tutorialstage;

    // Get fresh flags with current invasion data
    const flags = getFlags();
    flags.discordOldEnough = ctx.meetsDiscordAgeCheck;

    const responseBody = {
      ...filteredSave,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      champion: JSON.stringify(filteredSave.champion),
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      currenttime: getCurrentDateTime(),
      pic_square: `${process.env.AVATAR_URL}?seed=${
        filteredSave.name
      }&size=${50}`,
    };

    // Only include user save data if the base belongs to the current user
    // and is not an inferno base
    if (
      baseSave.type !== BaseType.INFERNO &&
      user.userid === filteredSave.userid
    ) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "The server failed to load this base." };
    errorLog(`Failed to load base`, err);
  }
};
