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
import { loadFailureErr } from "../../../errors/errors";
import { BaseMode } from "../../../enums/Base";
import { WORLD_SIZE } from "../../../config/WorldGenSettings";
import { Status } from "../../../enums/StatusCodes";
import { baseModeView } from "./modes/baseModeView";
import { baseModeBuild } from "./modes/baseModeBuild";
import { errorLog } from "../../../utils/logger";
import { baseModeAttack } from "./modes/baseModeAttack";

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
  try {
    const { baseid, type } = BaseLoadSchema.parse(ctx.request.body);
    const user: User = ctx.authUser;
    await ORMContext.em.populate(user, ["save"]);

    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(user, baseid);
        break;
      case BaseMode.VIEW:
        baseSave = await baseModeView(user, baseid);
        break;
      case BaseMode.ATTACK:
        baseSave = await baseModeAttack(user, baseid);
        break;
      default:
        throw new Error(`Base type not handled, type: ${type}.`);
    }

    const filteredSave = FilterFrontendKeys(baseSave);
    const isTutorialEnabled = devConfig.skipTutorial
      ? 205
      : filteredSave.tutorialstage;

    ctx.status = Status.OK;
    ctx.body = {
      ...filteredSave,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      outposts: user.save.outposts,
      currenttime: getCurrentDateTime(),
      pic_square: `${process.env.AVATAR_URL}?seed=${user.username}`,
    };
  } catch (error) {
    errorLog(`Error loading base: ${error.message}`);
    throw loadFailureErr();
  }
};
