import type { NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { Save } from "../../database/models/save.model.js";
import { postgres } from "../../server.js";
import { BaseType } from "../../enums/Base.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import { calculateBaseLevel } from "../base/calculateBaseLevel.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { getRecentOpponentIds } from "./attackHistory.js";
import { addNeighbours, removeNeighbours } from "./neighbours.js";
import { findNeighbours } from "./findNeighbours.js";
import { addFriendNeighbours } from "./v1/addFriendNeighbours.js";
import {
  NEIGHBOUR_DROP_LEVEL_RANGE,
  NEIGHBOUR_INACTIVE_DAYS,
  NEIGHBOUR_SOFT_CAP,
  NEIGHBOUR_TARGET,
} from "../../config/NeighbourConfig.js";

interface RefreshNeighbours {
  userId: number;
  save: Pick<Save, "points" | "basevalue">;
  neighbourIds: number[];
  friendIds: Set<number>;
  type: NeighbourAttackType;
}

interface RemoveIneligible {
  userId: number;
  userLevel: number;
  neighbourIds: number[];
  friendIds: Set<number>;
  type: NeighbourAttackType;
}

const NEIGHBOUR_SAVE_FIELDS = ["userid", "points", "basevalue", "savetime"] as const;

/**
 * Tidies a player's map and tops it up.
 *
 * Removes neighbours who no longer belong on it, adds any friends who are
 * missing, then adds new players until the map is back at its target size.
 * Friends are only added on Map Room 1; the Inferno map has no friend system.
 *
 * @param {RefreshNeighbours} options - Refresh options
 * @param {number} options.userId - The player whose map is being refreshed
 * @param {Pick<Save, "points" | "basevalue">} options.save - Their save on that map, for their level
 * @param {number[]} options.neighbourIds - Everyone on their map now
 * @param {Set<number>} options.friendIds - Their friends
 * @param {NeighbourAttackType} options.type - Which map is being refreshed
 * @returns {Promise<number[]>} Everyone on their map afterwards
 */
export const refreshNeighbours = async ({ userId, save, neighbourIds, friendIds, type }: RefreshNeighbours): Promise<number[]> => {
  const userLevel = calculateBaseLevel(save.points, save.basevalue);
  const isOverworld = type === BaseType.MAIN;

  const kept = await removeIneligible({ userId, userLevel, neighbourIds, friendIds, type });
  const friends = isOverworld ? await addFriendNeighbours(userId, userLevel, kept, friendIds) : [];
  
  const current = [...friends, ...kept];
  const shortfall = NEIGHBOUR_TARGET - current.length;

  if (shortfall <= 0) return current;

  const found = await findNeighbours({ userId, userLevel, neighbourIds: current, limit: shortfall, type });

  await addNeighbours(userId, found, type);

  return [...found, ...current];
};

/**
 * Removes neighbours who have left the map, drifted out of level range or gone
 * inactive. A pair who attacked each other recently stay neighbours whatever
 * their levels, and a friend is not removed for being inactive. A map still
 * over the cap after that is trimmed back to it.
 *
 * @param {RemoveIneligible} options - Removal options
 * @param {number} options.userId - The player whose map is being checked
 * @param {number} options.userLevel - Their level, the centre of the range
 * @param {number[]} options.neighbourIds - Everyone on their map now
 * @param {Set<number>} options.friendIds - Their friends
 * @param {NeighbourAttackType} options.type - Which map is being checked
 * @returns {Promise<number[]>} The neighbours who stay
 */
const removeIneligible = async ({ userId, userLevel, neighbourIds, friendIds, type }: RemoveIneligible): Promise<number[]> => {
  const isOverworld = type === BaseType.MAIN;

  const where = {
    type,
    userid: { $in: neighbourIds },
    ...(isOverworld && { mapversion: MapRoomVersion.V1 }),
  };

  const [neighbourSaves, opponentIds] = await Promise.all([
    postgres.em.find(Save, where, { fields: NEIGHBOUR_SAVE_FIELDS }),
    getRecentOpponentIds(userId, type),
  ]);

  const saves = new Map(neighbourSaves.map((neighbourSave) => [neighbourSave.userid, neighbourSave]));
  const inactiveSince = getCurrentDateTime() - NEIGHBOUR_INACTIVE_DAYS * 24 * 60 * 60;

  const shouldRemove = (neighbourId: number) => {
    const neighbourSave = saves.get(neighbourId);

    if (!neighbourSave) return true;
    if (opponentIds.has(neighbourId)) return false;

    const level = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);
    const isOutOfRange = Math.abs(level - userLevel) > NEIGHBOUR_DROP_LEVEL_RANGE;
    const isInactive = neighbourSave.savetime < inactiveSince && !friendIds.has(neighbourId);

    return isOutOfRange || isInactive;
  };

  const toRemove: number[] = [];
  const toKeep: number[] = [];

  for (const neighbourId of neighbourIds) {
    if (shouldRemove(neighbourId)) toRemove.push(neighbourId);
    else toKeep.push(neighbourId);
  }
  const overCap = overCapNeighbours(toKeep, opponentIds, friendIds);
  
  toRemove.push(...overCap);
  await removeNeighbours(userId, toRemove, type);

  const removed = new Set(toRemove);

  return toKeep.filter((neighbourId) => !removed.has(neighbourId));
};

/**
 * The neighbours to remove from a map that is over the cap, longest-standing
 * first: the list arrives newest first, so the excess comes off the end.
 * Recent opponents and friends are never chosen, so they are the only way a
 * map stays over the cap.
 *
 * @param {number[]} neighbourIds - Everyone on the map, newest first
 * @param {Set<number>} opponentIds - Players attacked, or attacked by, recently
 * @param {Set<number>} friendIds - The player's friends
 * @returns {number[]} The neighbours to remove, empty when the map is within the cap
 */
const overCapNeighbours = (neighbourIds: number[], opponentIds: Set<number>, friendIds: Set<number>): number[] => {
  const excess = neighbourIds.length - NEIGHBOUR_SOFT_CAP;

  if (excess <= 0) return [];

  const removable = neighbourIds.filter((neighbourId) => !opponentIds.has(neighbourId) && !friendIds.has(neighbourId));

  return removable.slice(-excess);
};
