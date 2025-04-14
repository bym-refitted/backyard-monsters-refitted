import { molochTribes } from "../../../../data/tribes/molochTribes";
import { InfernoMaproom, TribeData } from "../../../../models/infernomaproom.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const infernoModeAttack = async (user: User, baseid: string) => {
  const save = await ORMContext.em.findOne(Save, { baseid });

  if (save) return save;

  const maproom1 = await ORMContext.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };

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
