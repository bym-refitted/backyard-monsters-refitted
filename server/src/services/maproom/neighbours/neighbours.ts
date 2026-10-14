import type { UpsertManyOptions } from "@mikro-orm/core";

import type { NeighbourAttackType } from "../../../database/models/neighbourattack.model.js";
import { NeighbourLink } from "../../../database/models/neighbourlink.model.js";
import { postgres } from "../../../server.js";
import { createNeighbourData } from "./createNeighbourData.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";

/**
 * Everyone on a player's map. Each of them has this player on theirs.
 *
 * @param {number} userId - The player reading their map
 * @param {NeighbourAttackType} type - Which map to read
 * @returns {Promise<number[]>} Their neighbours' user ids, newest first
 */
export const getNeighbourIds = async (userId: number, type: NeighbourAttackType): Promise<number[]> => {
  const where = {
    type, 
    $or: [{ user_a_id: userId }, { user_b_id: userId }] 
  };
  
  const links = await postgres.em.find(NeighbourLink, where, {
    fields: ["user_a_id", "user_b_id"],
    orderBy: { created_at: "DESC" },
  });

  return links.map((link) => (link.user_a_id === userId ? link.user_b_id : link.user_a_id));
};

/**
 * Puts a player and each of the others on one another's maps. Pairs already
 * neighbours are left as they are. The lower user id always goes first, so a pair
 * can only ever have one row whichever of them is asking.
 *
 * @param {number} userId - The player
 * @param {number[]} otherIds - The players to make their neighbours
 * @param {NeighbourAttackType} type - Which map they are neighbours on
 */
export const addNeighbours = async (userId: number, otherIds: number[], type: NeighbourAttackType) => {
  if (otherIds.length === 0) return;

  const links = otherIds.map((otherId) => ({
    type,
    user_a_id: Math.min(userId, otherId),
    user_b_id: Math.max(userId, otherId),
  }));

  const options: UpsertManyOptions<NeighbourLink> = {
    onConflictFields: ["type", "user_a_id", "user_b_id"],
    onConflictAction: "ignore",
  };

  await postgres.em.upsertMany(NeighbourLink, links, options);
};

/**
 * Whether two players are on one another's maps.
 *
 * @param {number} userId - One player
 * @param {number} otherId - The other player
 * @param {NeighbourAttackType} type - Which map to check
 * @returns {Promise<boolean>} True when they are neighbours
 */
export const areNeighbours = async (userId: number, otherId: number, type: NeighbourAttackType): Promise<boolean> => {
  const where = {
    type,
    user_a_id: Math.min(userId, otherId),
    user_b_id: Math.max(userId, otherId),
  };

  const links = await postgres.em.count(NeighbourLink, where);

  return links > 0;
};

/**
 * Takes a player and each of the others off one another's maps.
 *
 * @param {number} userId - The player
 * @param {number[]} otherIds - The players to unlink them from
 * @param {NeighbourAttackType} type - Which map they are neighbours on
 */
export const removeNeighbours = async (userId: number, otherIds: number[], type: NeighbourAttackType) => {
  if (otherIds.length === 0) return;

  const where = {
    type,
    $or: [
      { user_a_id: userId, user_b_id: { $in: otherIds } },
      { user_b_id: userId, user_a_id: { $in: otherIds } },
    ],
  };

  await postgres.em.nativeDelete(NeighbourLink, where);
};

/**
 * Takes a player off every map, for when they leave the map room altogether.
 *
 * @param {number} userId - The player leaving
 * @param {NeighbourAttackType} type - Which map they are leaving
 */
export const removeAllNeighbours = async (userId: number, type: NeighbourAttackType) => {
  const where = {
    type,
    $or: [{ user_a_id: userId }, { user_b_id: userId }],
  };

  await postgres.em.nativeDelete(NeighbourLink, where);
};

/**
 * Who is on each of the given players' maps, read in one query.
 *
 * Reads plain rows: a search asks about 150 players at once, and building an
 * entity for each of their links costs ten times the query itself.
 *
 * @param {number[]} userIds - The players to read for
 * @param {NeighbourAttackType} type - Which map to read
 * @returns {Promise<Map<number, Set<number>>>} Neighbours by user id; an empty set for players with none
 */
export const getNeighbourIdsByUser = async (userIds: number[], type: NeighbourAttackType) => {
  const neighbourIdsByUser = new Map<number, Set<number>>();

  for (const userId of userIds) neighbourIdsByUser.set(userId, new Set());

  if (userIds.length === 0) return neighbourIdsByUser;

  const where = {
    type, 
    $or: [{ user_a_id: { $in: userIds } }, { user_b_id: { $in: userIds } }] 
  };

  const links = await postgres.em
    .createQueryBuilder(NeighbourLink, "link")
    .select(["link.user_a_id", "link.user_b_id"])
    .where(where)
    .execute<{ user_a_id: number; user_b_id: number }[]>("all", false);

  for (const { user_a_id, user_b_id } of links) {
    neighbourIdsByUser.get(user_a_id)?.add(user_b_id);
    neighbourIdsByUser.get(user_b_id)?.add(user_a_id);
  }

  return neighbourIdsByUser;
};

/**
 * Blank neighbour records for a list of players. Only the user id is
 * real: updateNeighbourData fills in everything a link does not store, and
 * drops anyone whose save is gone.
 *
 * @param {number[]} userIds - The players on the map
 * @returns {NeighbourData[]} One record per player, ready for updateNeighbourData
 */
export const toNeighbourData = (userIds: number[]): NeighbourData[] => {
  const blankUser = { username: "", pic_square: "" };

  return userIds.map((userid) => {
    const blankSave = { userid, baseid: "", lastupdateAt: new Date() };

    return createNeighbourData(blankSave, blankUser, 0);
  });
};
