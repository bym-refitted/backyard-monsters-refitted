import z from "zod";

import { flags } from "../../../data/flags";
import { BaseMode, BaseType } from "../../../enums/Base";
import { Status } from "../../../enums/StatusCodes";
import { saveFailureErr } from "../../../errors/errors";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { KoaController } from "../../../utils/KoaController";
import { baseModeBuild } from "../load/modes/baseModeBuild";
import { baseModeView } from "../load/modes/baseModeView";
import { errorLog } from "../../../utils/logger";
import { mapUserSaveData } from "../mapUserSaveData";

const UpdateSavedSchema = z.object({
  type: z.string(),
  version: z.string(),
  lastupdate: z.string(),
  baseid: z.string(),
});

/**
 * Controller responsible for handling periodic polling updates from the client every 30 seconds.
 * The update can occur in either "build" or "view" mode, depending on the type sent from the client.
 *
 * @param {object} ctx - The Koa context object.
 * @throws Will throw an error if the save operation fails.
 */
export const updateSaved: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  const userSave = user.save;
  
  try {
    const { baseid, type } = UpdateSavedSchema.parse(ctx.request.body);

    let baseSave: Save = null;

    if (type === BaseMode.BUILD) {
      baseSave = await baseModeBuild(user, baseid);
    } else {
      baseSave = await baseModeView(baseid);
    }

    if (!baseSave) throw saveFailureErr();

    baseSave.savetime = getCurrentDateTime();
    baseSave.id = baseSave.savetime; // client expects this.

    if (baseid !== BaseMode.DEFAULT && type === BaseMode.BUILD) {
      await ORMContext.em.persistAndFlush(baseSave);
    }

    const filteredSave = FilterFrontendKeys(baseSave);

    const responseBody = {
      error: 0,
      flags,
      ...filteredSave,
      credits: userSave.credits
    };

    if (baseSave.type !== BaseType.INFERNO && user.userid === filteredSave.userid) {
      Object.assign(responseBody, mapUserSaveData(user));
    }

    ctx.status = Status.OK;
    ctx.body = responseBody;
  } catch (err) {
    errorLog(`Failed to update save for user: ${user.username}`, err);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: 1 };
  }
};
