import { molochTribes } from "../../../../data/tribes/inferno/molochTribes.js";
import { InfernoMaproom, TribeData } from "../../../../models/infernomaproom.model.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";

export const infernoModeView = async (user: User, baseid: string) => {
  const save = await postgres.em.findOne(Save, { baseid });

  if (save) return save;

  const maproom1 = await postgres.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };

    maproom1.tribedata.push(newTribe);
    await postgres.em.persistAndFlush(maproom1);
  }

  const tribeData = molochTribes.find((tribe) => tribe.baseid === baseid);

  return Object.assign(new Save(), {
    ...tribeData,
    baseid,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
    monsters: existingTribe?.monsters ?? tribeData.monsters,
  });
};
