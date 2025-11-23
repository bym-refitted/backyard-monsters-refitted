import { Save } from "../../../../models/save.model";
import { postgres } from "../../../../server";
import { wildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";

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
export const baseModeView = async (baseid: string) => {
  let save = await postgres.em.findOne(Save, { baseid });

  if (!save) save = wildMonsterSave(baseid);

  if (save && save.wmid !== 0) {
    const currentTimestamp = getCurrentDateTime();

    if (currentTimestamp - save.savetime > WILD_MONSTER_EXPIRATION) {
      await postgres.em.removeAndFlush(save);
      save = wildMonsterSave(baseid);
    }
  }

  return save;
};
