import { redis } from "../../server.js";
import { BaseType } from "../../enums/Base.js";

type LastSeenList = Map<number, number>;

/**
 * Fetches last-seen timestamps for a list of user IDs from Redis and returns
 * them as a Map. Returns an empty Map if no IDs are provided.
 *
 * @param {number[]} ownerIds - List of user IDs to look up
 * @param {BaseType.MAIN | BaseType.INFERNO} type - Which last-seen namespace to query
 * @returns {Promise<LastSeenList>} Map of user ID to last-seen Unix timestamp
 */
export const getLastSeen = async (ownerIds: number[], type: BaseType.MAIN | BaseType.INFERNO): Promise<LastSeenList> => {
  if (!ownerIds.length) return new Map();

  const lastSeen = await redis.mget(...ownerIds.map((id) => `last-seen:${type}:${id}`));

  const map = new Map<number, number>();

  ownerIds.forEach((id, i) => {
    if (lastSeen[i]) map.set(id, parseInt(lastSeen[i]));
  });

  return map;
};
