import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Alliance } from "../../database/models/alliance.model.js";
import { getWorldMapVersion } from "../maproom/knownWorlds.js";

type AllianceHome = Pick<Alliance, "world_id" | "map_version">;

/**
 * Whether a player in the given world can belong to an alliance.
 *
 * A Map Room 2 alliance belongs to one world. A Map Room 3 alliance reaches across every Map Room 3 world:
 * players there relocate between worlds freely, and an alliance that could not
 * follow them would have to be left every time one moved next to a friend.
 *
 * @param {AllianceHome} alliance - The alliance.
 * @param {string | null | undefined} worldid - The player's world, absent when they are in none.
 * @returns {Promise<boolean>} True when the alliance can hold a player from that world.
 */
export const canJoinAlliance = async (alliance: AllianceHome, worldid: string | null | undefined): Promise<boolean> => {
  if (!worldid) return false;

  if (alliance.map_version !== MapRoomVersion.V3) return worldid === alliance.world_id;

  const mapVersion = await getWorldMapVersion(worldid);

  return mapVersion === MapRoomVersion.V3;
};
