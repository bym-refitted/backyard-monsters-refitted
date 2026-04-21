import { molochTribes } from "../../../../data/tribes/inferno/molochTribes.js";
import { InfernoMaproom, type TribeData } from "../../../../models/infernomaproom.model.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";

export const infernoModeView = async (user: User, baseid: string) => {
  const save = await postgres.em.findOne(Save, { baseid });

  if (save) return save;

  const maproomInferno = await postgres.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  if (!maproomInferno) throw new Error(`Inferno maproom not found for user: ${user.username}`);

  let existingTribe = maproomInferno.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };

    maproomInferno.tribedata.push(newTribe);
    postgres.em.persist(maproomInferno);
    await postgres.em.flush();
  }

  const tribeData = molochTribes.find((tribe) => tribe.baseid === baseid)!;

  return Object.assign(new Save(), {
    ...tribeData,
    baseid,
    buildinghealthdata: existingTribe?.tribeHealthData || {},
    monsters: existingTribe?.monsters ?? tribeData.monsters,
  });
};
