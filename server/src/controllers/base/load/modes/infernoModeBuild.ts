import { inferoMonsters } from "../../../../data/monsterKeys";
import { INFERNO_TRIBES } from "../../../../enums/Tribes";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { createScaledTribes } from "../../../../services/maproom/v1/createScaledTribes";
import { permissionErr } from "../../../../errors/errors";

/**
 * Retrieves the save data for the user based on their Inferno mode request.
 *
 * Attempts to fetch the user's Inferno base save, otherwise creates a new one
 * if it does not exist. Tribes are generated and scaled for the Inferno Map Room
 * based on the user's current level.
 *
 * The client always sends baseid 0 for Inferno mode requests regardless of
 * the actual base being accessed.
 *
 * @param {User} user - The user requesting Inferno mode access
 * @returns {Promise<Save>} A promise that resolves to the prepared Inferno save
 * @throws {Error} If user attempts to access an unauthorized base
 */
export const infernoModeBuild = async (user: User) => {
  const userSave = user.save;
  let infernoSave = user.infernosave;

  if (!infernoSave) infernoSave = await Save.createInfernoSave(ORMContext.em, user);

  if (infernoSave.userid !== user.userid) throw permissionErr();

  const { points, basevalue, stats } = infernoSave;
  infernoSave.level = calculateBaseLevel(points, basevalue);

  // Set worldid to match the user's main save for neighbor matching
  infernoSave.worldid = userSave.worldid;

  // Create Inferno tribes based on the user's current level
  infernoSave.wmstatus = await createScaledTribes(infernoSave, INFERNO_TRIBES);

  infernoSave.credits = userSave.credits;
  infernoSave.resources = userSave.iresources;
  userSave.stats["other"]["underhalLevel"] = stats["other"]["underhalLevel"];

  // Persist Inferno monster levels to overworld only if the values differ
  inferoMonsters.forEach((key) => {
    const acdaemyLevel = infernoSave.academy[key];

    if (acdaemyLevel && userSave.academy[key] !== acdaemyLevel)
      userSave.academy[key] = acdaemyLevel;
  });

  // Persist Inferno lockerdata to overworld
  Object.entries(infernoSave.lockerdata).forEach(([key, itemCount]) => {
    userSave.lockerdata[key] = itemCount;
  });

  await ORMContext.em.flush();
  return infernoSave;
};
