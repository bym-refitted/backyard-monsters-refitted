import { inferoMonsters } from "../../../../data/monsterKeys";
import { BaseType } from "../../../../enums/Base";
import { INFERNO_TRIBES } from "../../../../enums/Tribes";
import { Report } from "../../../../models/report.model";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { createScaledTribes } from "../../../../services/maproom/v1/createScaledTribes";
import { logReport } from "../../../../utils/logReport";

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
  let infernoSave = user.infernoSave;

  if (!infernoSave)
    infernoSave = await Save.createInfernoSave(ORMContext.em, user);

  if (infernoSave.userid !== user.userid) {
    const message = `${user.username} attempted to access unauthorized inferno base}`;
    await logReport(user, new Report(), message);
    throw new Error(message);
  }

  const { points, basevalue, stats } = infernoSave;
  infernoSave.level = calculateBaseLevel(points, basevalue);

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

  await ORMContext.em.flush();
  return infernoSave;
};
