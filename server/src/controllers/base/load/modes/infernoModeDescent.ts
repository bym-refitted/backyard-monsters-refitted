import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const infernoModeDescent = async (user: User) => {
  const { userid } = user.save;
  let baseSave = await ORMContext.em.findOne(Save, { userid });

  // If the user already has descent tribes, return the save.
  if (baseSave.wmstatus.length !== 0) return baseSave;

  // Otherwise, create an array of 13 descent tribes, client expects IDs between 201-213.
  const tribes = Array.from({ length: 13 }, (_, i) => [201 + i, i + 1, 0]);

  baseSave.wmstatus = tribes;
  await ORMContext.em.persistAndFlush(baseSave);

  return baseSave;
};
