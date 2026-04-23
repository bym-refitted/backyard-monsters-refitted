import { MapRoomVersion } from "../../enums/MapRoom.js";
import { tribeSaveV1 } from "./v1/tribeSaveV1.js";
import { tribeSaveV2 } from "./v2/tribeSaveV2.js";
import { tribeSaveV3 } from "./v3/tribeSaveV3.js";
import type { User } from "../../models/user.model.js";

/**
 * Generates a wild monster Save for the given baseid.
 * Routes to the correct version handler based on the client's map version.
 *
 * @param {string} baseid - The base ID
 * @param {MapRoomVersion} mapversion - The map room version from the client
 * @param {string} worldid - The world UUID (required for MR3 player yard defender lookups)
 * @param {User} user - The requesting user (required for MR1 per-user health tracking)
 * @returns {Promise<Save | null>} A new Save entity for the wild monster, or null
 */
export const tribeSaveHandler = (
  baseid: string,
  mapversion: MapRoomVersion | undefined,
  worldid: string | null | undefined,
  user: User,
) => {
  switch (mapversion) {
    case MapRoomVersion.V1:
      return tribeSaveV1(baseid, user);

    case MapRoomVersion.V3:
      if (!worldid)
        throw new Error("worldid is required for MR3 tribe save lookup.");
      return tribeSaveV3(baseid, worldid);

    case MapRoomVersion.V2:
      return tribeSaveV2(baseid, worldid);

    default:
      throw new Error("Map version is required for tribe save lookup.");
  }
};
