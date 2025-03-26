import { molochTribes } from "../../../../data/tribes/molochTribes";
import { InfernoMaproom } from "../../../../models/infernomaproom.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const infernoModeView = async (user: User, baseid: string) => {
  const userSave = await ORMContext.em.findOne(Save, { baseid });

  if (userSave) return userSave;

  const maproom1 = await ORMContext.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe = { baseid, tribeHealthData: {} };

    maproom1.tribedata.push(newTribe);
    await ORMContext.em.persistAndFlush(maproom1);
  }

  const tribeData = molochTribes.find((tribe) => tribe.baseid === baseid);

  return Object.assign(new Save(), {
    ...tribeData,
    baseid,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
  });
};
