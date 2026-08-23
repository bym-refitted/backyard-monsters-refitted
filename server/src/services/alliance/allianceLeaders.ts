import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

export type LeaderBaseIds = Promise<Map<number, string | null>>;

/**
 * Resolves the base the Visit Leader button drops a player into
 *
 * @param {number[]} leaderIds - The user ids to resolve.
 * @returns {LeaderBaseIds} Base id by user id; empty when no ids are given.
 */
export const getLeaderBaseIds = async (leaderIds: number[]): LeaderBaseIds => {
  if (leaderIds.length === 0) return new Map();

  const leaders = await postgres.em.find(
    User,
    { userid: { $in: leaderIds } },
    { fields: ["userid", "save.baseid"] }
  );

  return new Map(leaders.map((leader) => [leader.userid, leader.save?.baseid ?? null]));
};
