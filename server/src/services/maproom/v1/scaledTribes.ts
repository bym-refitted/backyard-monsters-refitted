import { TypeOf } from "zod";
import { resourcesHandler } from "../../../controllers/base/save/handlers/resourceHandler";
import { BaseSaveSchema } from "../../../controllers/base/save/zod/BaseSaveSchema";
import { molochTribes } from "../../../data/tribes/molochTribes";
import { SaveKeys } from "../../../enums/SaveKeys";
import { saveFailureErr } from "../../../errors/errors";
import { InfernoMaproom } from "../../../models/infernomaproom.model";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

type BaseSaveData = TypeOf<typeof BaseSaveSchema>;

export const scaledTribes = async (user: User, saveData: BaseSaveData) => {
  const userSave = user.save;
  const userInfernoSave = user.infernoSave;
  const currentSave = userInfernoSave || userSave;

  const maproom1 = await ORMContext.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === saveData.baseid
  );

  if (!existingTribe) throw saveFailureErr();

  // Update the existing tribe's health data
  existingTribe.tribeHealthData = saveData.buildinghealthdata;
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
  });

  await ORMContext.em.persistAndFlush(maproom1);

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
  await ORMContext.em.persistAndFlush(userSave);
  return tribeSave;
};
