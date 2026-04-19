import { inferoMonsters } from "../../../../data/stats/monsterKeys.js";
import { INFERNO_TRIBES } from "../../../../enums/Tribes.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
import { createScaledTribes } from "../../../../services/maproom/v1/createScaledTribes.js";
import { isAttackActive } from "../../../../services/base/isAttackActive.js";
import { baseUnderAttackErr, permissionErr } from "../../../../errors/errors.js";

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
  const userSave = user.save!;
  let infernoSave = user.infernosave;

  if (!infernoSave) infernoSave = await Save.createInfernoSave(postgres.em, user);

  if (infernoSave.userid !== user.userid) throw permissionErr();
  if (isAttackActive(infernoSave)) throw baseUnderAttackErr();

  const { points, basevalue, stats, academy, lockerdata } = infernoSave;
  infernoSave.level = calculateBaseLevel(points, basevalue);

  // Set worldid to match the user's main save for neighbor matching
  infernoSave.worldid = userSave.worldid;

  // Create Inferno tribes based on the user's current level
  infernoSave.wmstatus = await createScaledTribes(infernoSave, INFERNO_TRIBES);

  infernoSave.credits = userSave.credits;
  infernoSave.resources = userSave.iresources;

  if (userSave.stats?.["other"] && stats?.["other"])
    userSave.stats["other"]["underhalLevel"] = stats["other"]["underhalLevel"];

  // Persist Inferno monster levels to overworld only if the values differ
  if (academy) {
    inferoMonsters.forEach((key) => {
      const academyLevel = academy[key];
      
      if (academyLevel && (userSave.academy ??= {})[key] !== academyLevel)
        userSave.academy[key] = academyLevel;
    });
  }

  // Persist Inferno lockerdata to overworld
  if (lockerdata) {
    Object.entries(lockerdata).forEach(([key, itemCount]) => {
      (userSave.lockerdata ??= {})[key] = itemCount;
    });
  }

  await postgres.em.flush();
  return infernoSave;
};
