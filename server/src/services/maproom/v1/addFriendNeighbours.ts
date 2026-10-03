import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import {
  createNeighbourData,
  NEIGHBOUR_LEVEL_RANGE,
  NEIGHBOUR_SEARCH_SAVE_FIELDS,
  NEIGHBOUR_SEARCH_USER_FIELDS,
} from "../createNeighbourData.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";

/**
 * Puts friends at the front of the neighbour list, whether or not the cached search
 * happened to find them.
 *
 * @param {Save} save - The reader's main save, for the level the range is measured from.
 * @param {NeighbourData[]} neighbours - The cached list, untouched.
 * @param {Set<number>} friendIds - Their friends, resolved once by the caller.
 * @returns {Promise<NeighbourData[]>} The list with any missing friends in front of it.
 */
export const addFriendNeighbours = async (
  save: Save,
  neighbours: NeighbourData[],
  friendIds: Set<number>
): Promise<NeighbourData[]> => {
  if (friendIds.size === 0) return neighbours;

  const listed = new Set(neighbours.map((neighbour) => neighbour.userid));
  const missing = [...friendIds].filter((friendId) => !listed.has(friendId));

  if (missing.length === 0) return neighbours;

  const friendSaves = await postgres.em.find(
    Save,
    { type: BaseType.MAIN, mapversion: MapRoomVersion.V1, userid: { $in: missing } },
    { fields: NEIGHBOUR_SEARCH_SAVE_FIELDS }
  );

  const userLevel = calculateBaseLevel(save.points, save.basevalue);

  const inRange = friendSaves
    .map((friendSave) => ({
      save: friendSave,
      level: calculateBaseLevel(friendSave.points, friendSave.basevalue),
    }))
    .filter(({ level }) => Math.abs(level - userLevel) <= NEIGHBOUR_LEVEL_RANGE);

  if (inRange.length === 0) return neighbours;

  const friendUsers = await postgres.em.find(
    User,
    { userid: { $in: inRange.map(({ save: friendSave }) => friendSave.userid) } },
    { fields: NEIGHBOUR_SEARCH_USER_FIELDS }
  );

  const users = new Map(friendUsers.map((friend) => [friend.userid, friend]));

  const friendNeighbours = inRange.flatMap(({ save: friendSave, level }) => {
    const friendUser = users.get(friendSave.userid);

    return friendUser ? [createNeighbourData(friendSave, friendUser, level)] : [];
  });

  return [...friendNeighbours, ...neighbours];
};
