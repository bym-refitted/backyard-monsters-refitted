import { devConfig } from "../../../../config/DevSettings";
import { BaseType } from "../../../../enums/Base";
import { MapRoom1 } from "../../../../models/maproom1.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const infernoModeDescent = async (user: User) => {
  const { userid } = user.save;

  let baseSave = await ORMContext.em.findOne(Save, {
    userid,
    type: BaseType.MAIN,
  });

  const maproom1 = await ORMContext.em.findOne(MapRoom1, { userid });

  if (!maproom1) await MapRoom1.setupMapRoom1Data(ORMContext.em, user);

  // Otherwise, create an array of 13 descent tribes, client expects IDs between 201-213.
  const tribes = Array.from({ length: 13 }, (_, i) => [201 + i, i + 1, 0]);

  // Skip descent if the devConfig flag is set.
  if (devConfig.skipDescent) tribes.forEach((tribe) => (tribe[2] = 1));

  // If the user already has descent tribes, return the save.
  if (baseSave.wmstatus.length !== 0) return baseSave;

  baseSave.wmstatus = tribes;
  await ORMContext.em.flush();

  return baseSave;
};
