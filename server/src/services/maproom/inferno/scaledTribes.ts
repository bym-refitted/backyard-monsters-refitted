import type { TypeOf } from "zod";
import { resourcesHandler } from "../../../controllers/base/save/handlers/resourceHandler.js";
import { SaveKeys } from "../../../enums/SaveKeys.js";
import { saveFailureErr } from "../../../errors/errors.js";
import { InfernoMaproom } from "../../../models/infernomaproom.model.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { BaseSaveSchema } from "../../../zod/BaseSaveSchema.js";
import { molochTribes } from "../../../data/tribes/inferno/molochTribes.js";

type BaseSaveData = TypeOf<typeof BaseSaveSchema>;

export const scaledTribes = async (user: User, saveData: BaseSaveData) => {
  const userSave = user.save!;
  const userInfernoSave = user.infernosave;
  const currentSave = userInfernoSave || userSave!;

  const maproomInferno = await postgres.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  if (!maproomInferno) throw new Error(`Inferno MapRoom not found for userid: ${user.username}`);

  let existingTribe = maproomInferno.tribedata.find(
    (tribe) => tribe.baseid === saveData.baseid
  );

  if (!existingTribe) throw saveFailureErr();

  existingTribe.tribeHealthData = saveData.buildinghealthdata;
  existingTribe.monsters = saveData.monsters;
  existingTribe.destroyed = saveData.destroyed;
  existingTribe.destroyedAt = saveData.destroyed && getCurrentDateTime();

  // Update the wild monster status on the user save
  currentSave.wmstatus.forEach((tribe) => {
    if (tribe[0] === Number(saveData.baseid)) tribe[2] = saveData.destroyed ?? 0;
  });

  const tribeData = molochTribes.find(
    (tribe) => tribe.baseid === saveData.baseid
  );

  const tribeSave = Object.assign(new Save(), {
    ...tribeData,
    baseid: saveData.baseid,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
    monsters: existingTribe.monsters ?? tribeData?.monsters,
  });

  postgres.em.persist(maproomInferno);

  for (const key of Object.keys(saveData) as (keyof typeof saveData)[]) {
    const value = saveData[key];

    switch (key) {
      case SaveKeys.ATTACKCREATURES:
        currentSave.monsters = value;
        break;

      case SaveKeys.ATTACKERCHAMPION:
        if (saveData.attackerchampion) userSave.champion = saveData.attackerchampion;
        break;

      case SaveKeys.ATTACKLOOT:
        if (userInfernoSave)
          resourcesHandler(userSave, value, SaveKeys.IRESOURCES);
        break;
    }
  }
  postgres.em.persist(userSave);
  await postgres.em.flush();
  return tribeSave;
};
