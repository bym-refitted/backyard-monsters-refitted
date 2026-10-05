import { Save } from "../../../database/models/save.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import {
  NEIGHBOUR_INACTIVE_DAYS,
  NEIGHBOUR_LEVEL_RANGE,
  NEIGHBOUR_SEARCH_POOL_SIZE,
  NEIGHBOUR_SOFT_CAP,
} from "../../../config/NeighbourConfig.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getNeighbourIdsByUser } from "../neighbours.js";

/**
 * Finds MR1 players to make a player's neighbours: recently played, within level range,
 * not already on their map, and with room left on their own.
 *
 * @param {number} userId - The player being found neighbours
 * @param {number} userLevel - Their level, the centre of the range
 * @param {number[]} neighbourIds - Players already on their map
 * @param {number} limit - How many to find at most
 * @returns {Promise<number[]>} Their user ids, most recently played first
 */
export const findOverworldNeighbours = async (userId: number, userLevel: number, neighbourIds: number[], limit: number) => {
  const activeSince = getCurrentDateTime() - NEIGHBOUR_INACTIVE_DAYS * 24 * 60 * 60;

  const where = {
    type: BaseType.MAIN,
    mapversion: MapRoomVersion.V1,
    userid: { $nin: [userId, ...neighbourIds] },
    level: {
      $gte: userLevel - NEIGHBOUR_LEVEL_RANGE,
      $lte: userLevel + NEIGHBOUR_LEVEL_RANGE,
    },
    savetime: { $gte: activeSince },
  };

  const options = {
    fields: ["userid"],
    limit: NEIGHBOUR_SEARCH_POOL_SIZE,
    orderBy: { savetime: "DESC" },
  } as const;

  const saves = await postgres.em.find(Save, where, options);

  const inRange = saves.map((save) => save.userid);
  const neighbourIdsByUser = await getNeighbourIdsByUser(inRange, BaseType.MAIN);

  return inRange
    .filter((candidateId) => neighbourIdsByUser.get(candidateId)!.size < NEIGHBOUR_SOFT_CAP)
    .slice(0, limit);
};
