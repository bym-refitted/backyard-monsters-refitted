import z from "zod";

import { getFlags } from "../../../data/flags.js";
import { BaseMode, BaseType } from "../../../enums/Base.js";
import { Status } from "../../../enums/StatusCodes.js";
import { saveFailureErr } from "../../../errors/errors.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { baseModeBuild } from "../load/modes/baseModeBuild.js";
import { baseModeView } from "../load/modes/baseModeView.js";
import { infernoModeView } from "../load/modes/infernoModeView.js";
import { mapUserSaveData } from "../mapUserSaveData.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";

const UpdateSavedSchema = z.object({
  type: z.string(),
  version: z.string(),
  lastupdate: z.string(),
  baseid: z.string(),
  mapversion: z.coerce.number(),
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
  await postgres.em.populate(user, ["save"]);

  const userSave = user.save!;
  const worldid = user.save?.worldid;
  const { baseid, type, mapversion } = UpdateSavedSchema.parse(ctx.request.body);

  let baseSave: Save | null = null;

  switch (type) {
    case BaseMode.BUILD:
      baseSave = await baseModeBuild(user, baseid);
      break;

    case BaseMode.IVIEW:
    case BaseMode.IATTACK:
      baseSave = await infernoModeView(user, baseid);
      break;

    default:
      baseSave = await baseModeView(baseid, mapversion, worldid, user);
      break;
  }

  if (!baseSave) throw saveFailureErr();

  baseSave.savetime = getCurrentDateTime();
  baseSave.id = baseSave.savetime; // client expects this.

  if (baseid !== BaseMode.DEFAULT && type === BaseMode.BUILD) {
    postgres.em.persist(baseSave);
    await postgres.em.flush();
  }

  const filteredSave = FilterFrontendKeys(baseSave);

  const flags = getFlags();
  flags.discordOldEnough = Number(ctx.meetsDiscordAgeCheck);

  const townHall = extractTownHall(userSave.buildingdata || {});
  flags.maproom2 = userSave.mr2upgraded || (townHall && townHall.l >= 6) ? 1 : 0;
  flags.mr2upgraded = userSave.mr2upgraded ? 1 : 0;

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
};
