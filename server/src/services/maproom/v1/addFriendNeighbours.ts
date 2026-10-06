import { Friendship } from "../../../database/models/friendship.model.js";
import { Save } from "../../../database/models/save.model.js";
import { postgres } from "../../../server.js";
import { BaseType } from "../../../enums/Base.js";
import { FriendshipStatus } from "../../../enums/Friend.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { MAX_FRIEND_NEIGHBOURS, NEIGHBOUR_LEVEL_RANGE } from "../../../config/NeighbourConfig.js";
import { getNeighbourIdsByUser, addNeighbours } from "../neighbours.js";

/**
 * Which of the given friends can take one more friend on their own map. A link
 * lands on both players, so the limit has to hold on the other side too.
 *
 * @param {number[]} candidateIds - The friends about to be added.
 * @returns {Promise<number[]>} Those with fewer friends on their map than the limit.
 */
const withFriendRoom = async (candidateIds: number[]): Promise<number[]> => {
  const where = {
    status: FriendshipStatus.ACCEPTED,
    $or: [{ requester: { $in: candidateIds } }, { recipient: { $in: candidateIds } }],
  };

  const [friendships, neighbourIdsByUser] = await Promise.all([
    postgres.em.find(Friendship, where, { fields: ["requester", "recipient"] }),
    getNeighbourIdsByUser(candidateIds, BaseType.MAIN),
  ]);

  const friendNeighbours = new Map<number, number>();

  for (const friendship of friendships) {
    const pair = [friendship.requester.userid, friendship.recipient.userid];

    for (const [userId, otherId] of [pair, [...pair].reverse()]) {
      if (neighbourIdsByUser.get(userId)?.has(otherId)) {
        friendNeighbours.set(userId, (friendNeighbours.get(userId) ?? 0) + 1);
      }
    }
  }

  return candidateIds.filter((candidateId) => (friendNeighbours.get(candidateId) ?? 0) < MAX_FRIEND_NEIGHBOURS);
};

/**
 * Makes neighbours of a player and their friends on MR1 who are within level range and not on
 * their map yet. Stops once either player has ten friends on their map.
 *
 * @param {number} userId - The player whose map is being refreshed.
 * @param {number} userLevel - Their level, the centre of the range.
 * @param {number[]} neighbourIds - Everyone on their map now.
 * @param {Set<number>} friendIds - Their friends, resolved once by the caller.
 * @returns {Promise<number[]>} The friends just added, empty when there were none.
 */
export const addFriendNeighbours = async (userId: number, userLevel: number, neighbourIds: number[], friendIds: Set<number>) => {
  const onMap = new Set(neighbourIds);
  const missing = [...friendIds].filter((friendId) => !onMap.has(friendId));

  const room = MAX_FRIEND_NEIGHBOURS - (friendIds.size - missing.length);

  if (missing.length === 0 || room <= 0) return [];

  const where = {
    type: BaseType.MAIN,
    mapversion: MapRoomVersion.V1,
    userid: { $in: missing },
    level: {
      $gte: userLevel - NEIGHBOUR_LEVEL_RANGE,
      $lte: userLevel + NEIGHBOUR_LEVEL_RANGE,
    },
  };

  const friendSaves = await postgres.em.find(Save, where, { fields: ["userid"] });

  if (friendSaves.length === 0) return [];

  const candidates = await withFriendRoom(friendSaves.map((friendSave) => friendSave.userid));
  const accepted = candidates.slice(0, room);

  await addNeighbours(userId, accepted, BaseType.MAIN);

  return accepted;
};
