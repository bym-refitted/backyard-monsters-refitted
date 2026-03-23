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
  const userSave = user.save;
  const userInfernoSave = user.infernosave;
  const currentSave = userInfernoSave || userSave;

  const maproom1 = await postgres.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === saveData.baseid
  );

  if (!existingTribe) throw saveFailureErr();

  existingTribe.tribeHealthData = saveData.buildinghealthdata;
  existingTribe.monsters = saveData.monsters;
  existingTribe.destroyed = saveData.destroyed;
  existingTribe.destroyedAt = saveData.destroyed && getCurrentDateTime();
  
  // Update the wild monster status on the user save
  currentSave.wmstatus.forEach((tribe) => {
    if (tribe[0] === Number(saveData.baseid)) tribe[2] = saveData.destroyed;
  });

  const tribeData = molochTribes.find(
    (tribe) => tribe.baseid === saveData.baseid
  );

  const tribeSave = Object.assign(new Save(), {
    ...tribeData,
    baseid: saveData.baseid,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
    monsters: existingTribe.monsters ?? tribeData.monsters,
  });

  await postgres.em.persistAndFlush(maproom1);

  for (const key of Object.keys(saveData)) {
    const value = saveData[key];

    switch (key) {
      case SaveKeys.ATTACKCREATURES:
        currentSave.monsters = value;
        break;

      case SaveKeys.ATTACKERCHAMPION:
        userSave.champion = saveData.attackerchampion;
        break;

      case SaveKeys.ATTACKLOOT:
        if (userInfernoSave)
          resourcesHandler(userSave, value, SaveKeys.IRESOURCES);
        break;
    }
  }
  await postgres.em.persistAndFlush(userSave);
  return tribeSave;
};
