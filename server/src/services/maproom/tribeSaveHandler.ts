import { MapRoomVersion } from "../../enums/MapRoom.js";
import { tribeSaveV2 } from "./v2/tribeSaveV2.js";
import { tribeSaveV3 } from "./v3/tribeSaveV3.js";

/**
 * Generates a wild monster Save for the given baseid.
 * Routes to the correct version handler based on the client's map version.
 *
 * @param {string} baseid - The base ID
 * @param {MapRoomVersion} mapversion - The map room version from the client
 * @param {string} worldid - The world UUID (required for MR3 player yard defender lookups)
 * @returns {Promise<Save | null>} A new Save entity for the wild monster, or null
 */
export const tribeSaveHandler = (baseid: string, mapversion: MapRoomVersion | undefined, worldid?: string | null) => {
  if (!mapversion) throw new Error("Map version is required for tribe save lookup.");

  if (mapversion === MapRoomVersion.V3) {
    if (!worldid) throw new Error("worldid is required for MR3 tribe save lookup.");
    
    return tribeSaveV3(baseid, worldid);
  }

  return tribeSaveV2(baseid);
};
