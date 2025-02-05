import {
  descentTribeIds,
  descentTribes,
} from "../../../../data/tribes/descentTribes";
import { Save } from "../../../../models/save.model";
import { ORMContext } from "../../../../server";

export const infernoModeView = async (baseId: string) => {
  const baseid = BigInt(baseId);
  let save = new Save();

  // Return a descent tribe if baseid is a reserved descent tribe id.
  if (descentTribeIds.includes(Number(baseid))) {
    const tribeData = descentTribes.find(
      (tribe) => BigInt(tribe.baseid) === baseid
    );

    Object.assign(save, tribeData);
    return save;
  }

  save = await ORMContext.em.findOne(Save, { baseid });

  if (!save) {
    // TODO: Return an Inferno tribe here.
    // We do not need to persist this tribe to the database, since these tribes are unique
    // to the user on the Inferno map. Instead we can get it from a static file,
    // and only store the buildinghealthdata on the user's save object in a new column
    // which will keep track of the destruction done on the tribe.
    // This will save on database space and reduce the number of queries we need to make.
    // Data might looks like: {"baseid": "123", "buildinghealthdata": {"buildingid": 100, "health": 100}}
  }

  return save;
};
