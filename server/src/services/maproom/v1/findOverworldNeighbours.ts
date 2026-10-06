import { NeighbourCandidate } from "../../../database/models/neighbourcandidate.view.js";
import { postgres } from "../../../server.js";
import { NEIGHBOUR_INACTIVE_DAYS, NEIGHBOUR_LEVEL_RANGE, NEIGHBOUR_SOFT_CAP } from "../../../config/NeighbourConfig.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

/**
 * Finds MR1 players to make a player's neighbours: recently played, within level range,
 * not already on their map, and with room left on their own.
 *
 * Players with the fewest neighbours come first, so new and thin maps fill
 * before full ones are added to, then whoever played most recently.
 *
 * @param {number} userId - The player being found neighbours
 * @param {number} userLevel - Their level, the centre of the range
 * @param {number[]} neighbourIds - Players already on their map
 * @param {number} limit - How many to find at most
 * @returns {Promise<number[]>} Their user ids, most room first
 */
export const findOverworldNeighbours = async (userId: number, userLevel: number, neighbourIds: number[], limit: number) => {
  const activeSince = getCurrentDateTime() - NEIGHBOUR_INACTIVE_DAYS * 24 * 60 * 60;

  const where = {
    userid: { $nin: [userId, ...neighbourIds] },
    level: {
      $gte: userLevel - NEIGHBOUR_LEVEL_RANGE,
      $lte: userLevel + NEIGHBOUR_LEVEL_RANGE,
    },
    savetime: { $gte: activeSince },
    neighbours: { $lt: NEIGHBOUR_SOFT_CAP },
  };

  const options = {
    fields: ["userid"],
    limit,
    orderBy: { neighbours: "ASC", savetime: "DESC" },
  } as const;

  const candidates = await postgres.em.find(NeighbourCandidate, where, options);

  return candidates.map((candidate) => candidate.userid);
};
