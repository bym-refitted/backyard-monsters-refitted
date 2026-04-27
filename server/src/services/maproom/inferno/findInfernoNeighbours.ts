import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import { createNeighbourData } from "../createNeighbourData.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";

/**
 * Calculate inferno neighbours for a user and return data suitable for caching.
 *
 * Note: Commented-out worldid constraint (line 36) to allow cross-world matchmaking in Inferno.
 * In the original game this was same-world only, but it severely limits the pool of potential neighbours
 * and leads to empty lists for many players with low population worlds.
 *
 * @param {User} user - The authenticated user to find neighbours for
 * @returns {Promise<NeighbourData[]>} - Array of neighbour data suitable for caching
 */
export const findInfernoNeighbours = async (user: User): Promise<NeighbourData[]> => {
  const { infernosave, save } = user;

  if (!save?.worldid || !infernosave) return [];

  const userLevel = calculateBaseLevel(infernosave.points, infernosave.basevalue);
  const levelRange = 7;
  const minLevel = Math.max(1, userLevel - levelRange);
  const maxLevel = userLevel + levelRange;

  const validNeighbours: Array<{ save: Save; level: number }> = [];
  const userIds = new Set<number>();

  const infernoSaves = await postgres.em.find(
    Save,
    {
      type: BaseType.INFERNO,
      // worldid: infernosave.worldid,
      userid: { $ne: user.userid },
    },
    {
      limit: 150,
      orderBy: { lastupdateAt: "DESC" },
    }
  );

  for (const neighbourSave of infernoSaves) {
    const neighbourLevel = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);

    if (neighbourLevel >= minLevel && neighbourLevel <= maxLevel) {
      validNeighbours.push({ save: neighbourSave, level: neighbourLevel });
      userIds.add(neighbourSave.userid);

      if (validNeighbours.length >= 25) break;
    }
  }

  const neighbourUsers = await postgres.em.find(User, {
    userid: { $in: Array.from(userIds) },
  });

  const users = new Map<number, User>();
  neighbourUsers.forEach((u) => users.set(u.userid, u));

  const cachedNeighbours: NeighbourData[] = [];

  for (const { save: neighbourSave, level } of validNeighbours) {
    const neighbourUser = users.get(neighbourSave.userid);
    if (neighbourUser) cachedNeighbours.push(createNeighbourData(neighbourSave, neighbourUser, level));
  }

  return cachedNeighbours;
};
