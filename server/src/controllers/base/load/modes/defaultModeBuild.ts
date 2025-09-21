import { Save } from "../../../../models/save.model";
import { ORMContext } from "../../../../server";
import { balancedReward } from "../../../../services/base/balancedReward";
import { getActiveInvasion } from "../../../../services/events/wmi/getActiveInvasion";
import { Invasion } from "../../../../enums/Invasion";
import { setupInvasionEvent } from "../../../../services/events/wmi/setupInvasionEvent";
import { resetInvasionWaves } from "../../../../services/events/wmi/invasionUtils";

/**
 * Default mode runs once initally when a user first loads their save after login.
 * Useful for setting up inital values and states.
 *
 * 1) Checks for active invasions and resets waves if necessary.
 * 2) Applies balanced rewards to the user's save if applicable.
 *
 * @param {Save} userSave - The user's save data to be processed.
 * @returns {Promise<Save>} - The updated save data after processing.
 */
export const defaultModeBuild = async (userSave: Save) => {
  const activeInvasion = getActiveInvasion();

  if (userSave.stats?.other) 
    resetInvasionWaves(userSave.stats.other, activeInvasion);

  await balancedReward(userSave);
  await ORMContext.em.persistAndFlush(userSave);
  return userSave;
};
