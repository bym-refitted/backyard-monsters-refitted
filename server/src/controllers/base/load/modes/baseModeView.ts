import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { getWildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";

/**
 * The expiration time for a wild monster save in seconds.
 * 12 hours.
 */
const WILD_MONSTER_EXPIRATION = 43200;

/**
 * Handles viewing the base mode for a given base ID.
 * If the save is outdated for a wild monster, it removes the old save and creates a new one.
 *
 * @param {User} user - The authenticated user object.
 * @param {string} baseid - The base identifier for the requested save.
 * @returns {Promise<Loaded<Save, never>>} The save object or null if no valid save is found.
 */
export const baseModeView = async (user: User, baseid: string) => {
  const userSave: Save = user.save;
  let save = await ORMContext.em.findOne(Save, { baseid });

  if (!save) save = getWildMonsterSave(parseInt(baseid), userSave.worldid);

  if (save && save.wmid !== 0) {
    const currentTimestamp = Math.floor(Date.now() / 1000);

    if (currentTimestamp - save.savetime > WILD_MONSTER_EXPIRATION) {
      await ORMContext.em.removeAndFlush(save);
      save = getWildMonsterSave(parseInt(baseid), userSave.worldid);
    }
  }

  return save;
};
