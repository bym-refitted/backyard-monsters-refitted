import { molochTribes } from "../../data/tribes/molochTribes";
import { Status } from "../../enums/StatusCodes";
import { saveFailureErr } from "../../errors/errors";
import { ClientSafeError } from "../../middleware/clientSafeError";
import { MapRoom1 } from "../../models/maproom1.model";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import { errorLog } from "../../utils/logger";
import { BaseSaveSchema } from "../base/save/zod/BaseSaveSchema";

export const infernoSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const userSave = user.save;
  await ORMContext.em.populate(user, ["save"]);

  try {
    const saveData = BaseSaveSchema.parse(ctx.request.body);
    let tribeSave: Save = null;

    // Attempt to find the save data for the inferno base
    const infernoSave = await ORMContext.em.findOne(Save, {
      baseid: saveData.baseid,
    });

    // Otherwise, retrieve a moloch base
    if (!infernoSave) {
      const maproom1 = await ORMContext.em.findOne(MapRoom1, {
        userid: user.userid,
      });

      let existingTribe = maproom1.tribedata.find(
        (tribe) => BigInt(tribe.baseid) === saveData.baseid
      );

      if (!existingTribe) throw saveFailureErr();

      existingTribe.tribeHealthData = saveData.buildinghealthdata;

      const tribeData = molochTribes.find(
        (tribe) => tribe.baseid === saveData.baseid
      );

      tribeSave = Object.assign(new Save(), {
        ...tribeData,
        buildinghealthdata: existingTribe?.tribeHealthData || {},
        baseid: saveData.baseid.toString(),
      });

      await ORMContext.em.persistAndFlush(maproom1);
    }

    if (infernoSave) await ORMContext.em.persistAndFlush(infernoSave);

    const filteredSave = FilterFrontendKeys(
      tribeSave ? tribeSave : infernoSave
    );

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      ...filteredSave,
    };
  } catch (err) {
    errorLog(`Failed to save inferno base for user: ${user.username}`, err);

    if (err instanceof ClientSafeError) throw err;
    throw new Error("An unexpected error occurred while saving this base.");
  }
};
