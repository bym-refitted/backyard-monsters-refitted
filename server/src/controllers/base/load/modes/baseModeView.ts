import { MapRoomVersion } from "../../../../enums/MapRoom.js";
import { Save } from "../../../../models/save.model.js";
import { postgres } from "../../../../server.js";
import { tribeSaveHandler } from "../../../../services/maproom/tribeSaveHandler.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";

/**
 * The expiration time for a wild monster save in seconds.
 * 12 hours.
 */
const WILD_MONSTER_EXPIRATION = 43200;

/**
 * Handles viewing the base mode for a given base ID.
 * If the save is outdated for a wild monster, it removes the old save and creates a new one.
 *
 * @param {string} baseid - The base identifier for the requested save.
 * @param {MapRoomVersion} mapversion - The version of the map to determine the save handling logic.
 * @param {string} worldid - The world UUID, passed through for MR3 player yard defender lookups.
 * @returns {Promise<Loaded<Save, never>>} The save object or null if no valid save is found.
 */
export const baseModeView = async (baseid: string, mapversion: MapRoomVersion, worldid: string) => {
  let save = await postgres.em.findOne(Save, { baseid });

  if (!save) save = await tribeSaveHandler(baseid, mapversion, worldid);

  if (mapversion !== MapRoomVersion.V3 && save && save.wmid !== 0) {
    const currentTimestamp = getCurrentDateTime();

    if (currentTimestamp - save.savetime > WILD_MONSTER_EXPIRATION) {
      await postgres.em.removeAndFlush(save);
      save = await tribeSaveHandler(baseid, mapversion, worldid);
    }
  }

  return save;
};
