import { MapRoomVersion } from "../../enums/MapRoom.js";
import { tribeSaveV2 } from "./v2/tribeSaveV2.js";
import { tribeSaveV3 } from "./v3/tribeSaveV3.js";

/**
 * Generates a wild monster Save for the given baseid.
 * Routes to the correct version handler based on the client's map version.
 *
 * @param {string} baseid - The base ID
 * @param {MapRoomVersion} mapversion - The map room version from the client
 * @returns {Save | null} A new Save entity for the wild monster, or null
 */
export const tribeSaveHandler = (baseid: string, mapversion: MapRoomVersion) => {
  if (mapversion === MapRoomVersion.V3) return tribeSaveV3(baseid);

  return tribeSaveV2(baseid);
};
