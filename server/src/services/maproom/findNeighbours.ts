import type { NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { NeighbourCandidate } from "../../database/models/neighbourcandidate.view.js";
import { postgres } from "../../server.js";
import { NEIGHBOUR_INACTIVE_DAYS, NEIGHBOUR_LEVEL_RANGE, NEIGHBOUR_SOFT_CAP } from "../../config/NeighbourConfig.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";

interface FindNeighbours {
  userId: number;
  userLevel: number;
  neighbourIds: number[];
  limit: number;
  type: NeighbourAttackType;
}

/**
 * Finds players to make a player's neighbours: recently played, within level range,
 * not already on their map, and with room left on their own.
 *
 * Players with the fewest neighbours come first, so new and thin maps fill
 * before full ones are added to, then whoever played most recently.
 *
 * @param {FindNeighbours} options - Search options
 * @param {number} options.userId - The player being found neighbours
 * @param {number} options.userLevel - Their level, the centre of the range
 * @param {number[]} options.neighbourIds - Players already on their map
 * @param {number} options.limit - How many to find at most
 * @param {NeighbourAttackType} options.type - Which map to search
 * @returns {Promise<number[]>} Their user ids, most room first
 */
export const findNeighbours = async ({ userId, userLevel, neighbourIds, limit, type }: FindNeighbours): Promise<number[]> => {
  const activeSince = getCurrentDateTime() - NEIGHBOUR_INACTIVE_DAYS * 24 * 60 * 60;

  const where = {
    type,
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
