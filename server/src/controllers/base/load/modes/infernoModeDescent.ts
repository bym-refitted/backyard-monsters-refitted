import { devConfig } from "../../../../config/DevSettings";
import { BaseType } from "../../../../enums/Base";
import { InfernoMaproom } from "../../../../models/infernomaproom.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { postgres } from "../../../../server";

export const infernoModeDescent = async (user: User) => {
  const { userid } = user.save;

  let baseSave = await postgres.em.findOne(Save, {
    userid,
    type: BaseType.MAIN,
  });

  const maproom1 = await postgres.em.findOne(InfernoMaproom, { userid });

  if (!maproom1) await InfernoMaproom.setupMapRoom1Data(postgres.em, user);

  // Otherwise, create an array of 13 descent tribes, client expects IDs between 201-213.
  const tribes = Array.from({ length: 13 }, (_, i) => [201 + i, i + 1, 0]);

  // Skip descent if the devConfig flag is set.
  if (devConfig.skipDescent) tribes.forEach((tribe) => (tribe[2] = 1));

  // If the user already has descent tribes, return the save.
  if (baseSave.wmstatus.length !== 0) return baseSave;

  baseSave.wmstatus = tribes;
  await postgres.em.flush();

  return baseSave;
};
