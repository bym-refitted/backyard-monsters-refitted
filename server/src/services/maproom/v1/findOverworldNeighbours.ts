import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import {
  createNeighbourData,
  NEIGHBOUR_SEARCH_SAVE_FIELDS,
  NEIGHBOUR_SEARCH_USER_FIELDS,
} from "../createNeighbourData.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";

/**
 * Find MR1 overworld neighbours for a user and return data suitable for caching.
 *
 * Finds all Map Room 1 players within a specified level range.
 *
 * @param {User} user - The authenticated user to find neighbours for
 * @param {Save} save - The user's main save
 * @returns {Promise<NeighbourData[]>} - Array of neighbour data suitable for caching
 */
export const findOverworldNeighbours = async (user: User, save: Save): Promise<NeighbourData[]> => {
  const userLevel = calculateBaseLevel(save.points, save.basevalue);
  const levelRange = 7;
  const minLevel = Math.max(1, userLevel - levelRange);
  const maxLevel = userLevel + levelRange;

  const saves = await postgres.em.find(
    Save,
    {
      type: BaseType.MAIN,
      userid: { $ne: user.userid },
      mapversion: MapRoomVersion.V1,
    },
    {
      fields: NEIGHBOUR_SEARCH_SAVE_FIELDS,
      limit: 150,
      orderBy: { lastupdateAt: "DESC" },
    }
  );

  const validNeighbours: Array<{ save: (typeof saves)[number]; level: number }> = [];
  const userIds = new Set<number>();

  for (const neighbourSave of saves) {
    const level = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);

    if (level >= minLevel && level <= maxLevel) {
      validNeighbours.push({ save: neighbourSave, level });
      userIds.add(neighbourSave.userid);

      if (validNeighbours.length >= 25) break;
    }
  }

  const neighbourUsers = await postgres.em.find(
    User,
    { userid: { $in: Array.from(userIds) } },
    { fields: NEIGHBOUR_SEARCH_USER_FIELDS }
  );

  const users = new Map(neighbourUsers.map((u) => [u.userid, u]));

  const cachedNeighbours: NeighbourData[] = [];

  for (const { save: neighbourSave, level } of validNeighbours) {
    const neighbourUser = users.get(neighbourSave.userid);
    if (neighbourUser) cachedNeighbours.push(createNeighbourData(neighbourSave, neighbourUser, level));
  }

  return cachedNeighbours;
};
