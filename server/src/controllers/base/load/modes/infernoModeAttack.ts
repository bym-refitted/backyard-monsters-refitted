import { molochTribes } from "../../../../data/tribes/molochTribes";
import { MapRoom1 } from "../../../../models/maproom1.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const infernoModeAttack = async (user: User, baseId: string) => {
  const baseid = BigInt(baseId);

  const userSave = await ORMContext.em.findOne(Save, { baseid });
  if (userSave) return userSave;

  const maproom1 = await ORMContext.em.findOne(MapRoom1, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => BigInt(tribe.baseid) === baseid
  );

  if (!existingTribe) {
    const newTribe = { baseid: Number(baseid), tribeHealthData: {}}; 
    
    maproom1.tribedata.push(newTribe);
    await ORMContext.em.persistAndFlush(maproom1);
  }

  const tribeData = molochTribes.find((tribe) => tribe.baseid === baseid);

  return Object.assign(new Save(), {
    ...tribeData,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
    baseid: baseId,
  });
};
