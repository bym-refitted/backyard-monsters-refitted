import { Save } from "../../../database/models/save.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getRecentOpponentIds } from "../attackHistory.js";
import { addNeighbours, removeNeighbours } from "../neighbours.js";
import { findOverworldNeighbours } from "./findOverworldNeighbours.js";
import { addFriendNeighbours } from "./addFriendNeighbours.js";
import {
  NEIGHBOUR_DROP_LEVEL_RANGE,
  NEIGHBOUR_INACTIVE_DAYS,
  NEIGHBOUR_TARGET,
} from "../../../config/NeighbourConfig.js";

interface RefreshNeighbours {
  userId: number;
  save: Pick<Save, "points" | "basevalue">;
  neighbourIds: number[];
  friendIds: Set<number>;
}

interface RemoveIneligible {
  userId: number;
  userLevel: number;
  neighbourIds: number[];
  friendIds: Set<number>;
}

const NEIGHBOUR_SAVE_FIELDS = ["userid", "points", "basevalue", "savetime"] as const;

/**
 * Tidies a player's MR1 map and tops it up.
 *
 * Removes neighbours who no longer belong on it, adds any friends who are
 * missing, then adds new players until the map is back at its target size.
 *
 * @param {RefreshNeighbours} options - Refresh options
 * @param {number} options.userId - The player whose map is being refreshed
 * @param {Pick<Save, "points" | "basevalue">} options.save - Their main save, for their level
 * @param {number[]} options.neighbourIds - Everyone on their map now
 * @param {Set<number>} options.friendIds - Their friends
 * @returns {Promise<number[]>} Everyone on their map afterwards
 */
export const refreshNeighbours = async ({ userId, save, neighbourIds, friendIds }: RefreshNeighbours): Promise<number[]> => {
  const userLevel = calculateBaseLevel(save.points, save.basevalue);

  const kept = await removeIneligible({ userId, userLevel, neighbourIds, friendIds });
  const friends = await addFriendNeighbours(userId, userLevel, kept, friendIds);
  
  const current = [...friends, ...kept];
  const shortfall = NEIGHBOUR_TARGET - current.length;

  if (shortfall <= 0) return current;

  const found = await findOverworldNeighbours(userId, userLevel, current, shortfall);

  await addNeighbours(userId, found, BaseType.MAIN);

  return [...found, ...current];
};

/**
 * Removes neighbours who have left MR1, drifted out of level range or gone
 * inactive. A pair who attacked each other recently stay neighbours whatever
 * their levels, and a friend is not removed for being inactive.
 *
 * @param {RemoveIneligible} options - Removal options
 * @param {number} options.userId - The player whose map is being checked
 * @param {number} options.userLevel - Their level, the centre of the range
 * @param {number[]} options.neighbourIds - Everyone on their map now
 * @param {Set<number>} options.friendIds - Their friends
 * @returns {Promise<number[]>} The neighbours who stay
 */
const removeIneligible = async ({ userId, userLevel, neighbourIds, friendIds }: RemoveIneligible): Promise<number[]> => {
  const where = {
    type: BaseType.MAIN,
    mapversion: MapRoomVersion.V1,
    userid: { $in: neighbourIds },
  };

  const [neighbourSaves, opponentIds] = await Promise.all([
    postgres.em.find(Save, where, { fields: NEIGHBOUR_SAVE_FIELDS }),
    getRecentOpponentIds(userId, BaseType.MAIN),
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

  await removeNeighbours(userId, toRemove, BaseType.MAIN);

  return toKeep;
};
