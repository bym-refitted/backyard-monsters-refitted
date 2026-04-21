import { devConfig } from "../../../../config/GameConfig.js";
import { BaseType } from "../../../../enums/Base.js";
import { InfernoMaproom } from "../../../../models/infernomaproom.model.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";

/**
 * Handles the initial descent into the Inferno cavern.
 *
 * Returns the player's main save populated with 13 descent tribe entries
 * (baseids 201–213) in wmstatus. These are the static Moloch tribes the
 * client displays on the descent screen before the player reaches the
 * Inferno map room.
 *
 * Descent tribes are written once and preserved across subsequent loads —
 * if any 201–213 entry is already present the save is returned as-is.
 * Non-descent entries in wmstatus (e.g. MR1 tribe slots) are left untouched.
 *
 * @param {User} user - The authenticated user entering the Inferno
 * @returns {Promise<Save>} The player's main save with descent tribes set in wmstatus
 */
export const infernoModeDescent = async (user: User) => {
  const { userid } = user.save!;

  let baseSave = await postgres.em.findOne(Save, { userid, type: BaseType.MAIN });

  if (!baseSave) throw new Error(`Main save not found for user: ${user.username}`);

  const maproomInferno = await postgres.em.findOne(InfernoMaproom, { userid });

  if (!maproomInferno) await InfernoMaproom.setupInfernoMapRoomData(postgres.em, user);

  // Otherwise, create an array of 13 descent tribes, client expects IDs between 201-213.
  const tribes = Array.from({ length: 13 }, (_, i) => [201 + i, i + 1, 0]);

  // Skip descent if the devConfig flag is set.
  if (devConfig.skipDescent) tribes.forEach((tribe) => (tribe[2] = 1));

  const isDescentTribe = (tribe: number[]) => tribe[0] >= 201 && tribe[0] <= 213;

  if (baseSave.wmstatus.some(isDescentTribe)) return baseSave;

  const wmstatus = [...baseSave.wmstatus.filter((tribe) => !isDescentTribe(tribe)), ...tribes];

  baseSave.wmstatus = wmstatus;
  await postgres.em.flush();

  return baseSave;
};
