import z from "zod";

import { devConfig } from "../../../config/DevSettings";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { KoaController } from "../../../utils/KoaController";
import { storeItems } from "../../../data/storeItems";
import { User } from "../../../models/user.model";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { flags } from "../../../data/flags";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { BaseMode, BaseType } from "../../../enums/Base";
import { WORLD_SIZE } from "../../../config/WorldGenSettings";
import { Status } from "../../../enums/StatusCodes";
import { baseModeView } from "./modes/baseModeView";
import { baseModeBuild } from "./modes/baseModeBuild";
import { errorLog } from "../../../utils/logger";
import { baseModeAttack } from "./modes/baseModeAttack";
import { mapUserSaveData } from "../mapUserSaveData";
import { discordAgeErr } from "../../../errors/errors";
import { infernoModeDescent } from "./modes/infernoModeDescent";
import { infernoModeView } from "./modes/infernoModeView";
import { infernoModeAttack } from "./modes/infernoModeAttack";
import { infernoModeBuild } from "./modes/infernoModeBuild";

const BaseLoadSchema = z.object({
  type: z.string(),
  userid: z.string(),
  baseid: z.string(),
});

/**
 * Controller responsible for loading base modes based on the user's request.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base load process is complete.
 * @throws Will throw an error if the base load process fails.
 */
export const baseLoad: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const { baseid, type } = BaseLoadSchema.parse(ctx.request.body);

    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(user, baseid);
        break;

      case BaseMode.VIEW:
        baseSave = await baseModeView(baseid);
        break;

      case BaseMode.ATTACK:
        if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();
        baseSave = await baseModeAttack(user, baseid);
        break;

      case BaseMode.IDESCENT:
        baseSave = await infernoModeDescent(user);
        break;

      case BaseMode.IBUILD:
        baseSave = await infernoModeBuild(user, baseid);
        break;

      case BaseMode.IWMVIEW:
        baseSave = await infernoModeView(user, baseid);
      break;

      case BaseMode.IWMATTACK:
        baseSave = await infernoModeAttack(user, baseid);
        break;
      default:
        throw new Error(`Base type not handled, type: ${type}.`);
    }

    const filteredSave = FilterFrontendKeys(baseSave);
    const isTutorialEnabled = devConfig.skipTutorial
      ? 205
      : filteredSave.tutorialstage;

    flags.discordOldEnough = ctx.meetsDiscordAgeCheck;

    const responseBody = {
      ...filteredSave,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      currenttime: getCurrentDateTime(),
      pic_square: `${process.env.AVATAR_URL}?seed=${
        filteredSave.name
      }&size=${50}`,
    };

    // Only include user save data if the base belongs to the current user
    // and is not an inferno base
    if (baseSave.type !== BaseType.INFERNO && user.userid === filteredSave.userid) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    errorLog(`Failed to load base`, err);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
  }
};
