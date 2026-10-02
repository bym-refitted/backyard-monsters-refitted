import { QueryOrder, raw, type FilterQuery, type Loaded, type QueryOrderMap } from "@mikro-orm/core";

import { BaseType } from "../../enums/Base.js";
import { FriendRelation, FriendshipStatus } from "../../enums/Friend.js";
import { PLAYER_SEARCH_LIMIT } from "../../config/FriendConfig.js";
import { Friendship } from "../../database/models/friendship.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { calculateBaseLevel } from "../base/calculateBaseLevel.js";
import { escapeLike } from "../../utils/escapeLike.js";
import { getLastSeen } from "../maproom/getLastSeen.js";

interface FriendPlayerSource {
  userid: number;
  username: string;
  pic_square?: string | null;
  points?: string | null;
  basevalue?: string | null;
}

interface FriendshipRow {
  id: number;
  status: FriendshipStatus;
  created_at: Date;
  responded_at: Date | null;
  requester_userid: number;
  recipient_userid: number;
  requester_username: string;
  requester_pic: string | null;
  requester_points: string | null;
  requester_basevalue: string | null;
  recipient_username: string;
  recipient_pic: string | null;
  recipient_points: string | null;
  recipient_basevalue: string | null;
}

export interface FriendPlayer {
  user_id: number;
  username: string;
  pic_square: string | null;
  level: number;
  online: boolean;
}

export interface FriendEntry extends FriendPlayer {
  since: Date | null;
}

export interface FriendRequestEntry extends FriendPlayer {
  request_id: number;
  sent_at: Date;
}

export interface FriendList {
  friends: FriendEntry[];
  incoming: FriendRequestEntry[];
  outgoing: FriendRequestEntry[];
}

export interface PlayerSearchResult extends FriendPlayer {
  relation: FriendRelation;
  request_id: number | null;
}

type RelationRow = Loaded<Friendship, never, (typeof RELATION_FIELDS)[number]>;

const PLAYER_FIELDS = [
  "userid",
  "username",
  "pic_square",
  "blockedUsers",
  "save.points",
  "save.basevalue",
] as const;

const RELATION_FIELDS = [
  "id", 
  "status", 
  "requester", 
  "recipient"
] as const;

/**
 * Describes one player for the launcher's friend lists and search results.
 *
 * @param {FriendPlayerSource} player - The player, read with their main save's points.
 * @param {Map<number, number>} lastSeen - Who is currently online, by user id.
 * @returns {FriendPlayer} The player's row.
 */
const toFriendPlayer = (player: FriendPlayerSource, lastSeen: Map<number, number>): FriendPlayer => ({
  user_id: player.userid,
  username: player.username,
  pic_square: player.pic_square ?? null,
  level: player.points && player.basevalue ? calculateBaseLevel(player.points, player.basevalue) : 0,
  online: lastSeen.has(player.userid),
});

/**
 * Reads one side of a friendship row, whose two players are flattened into
 * columns named after the side they sit on.
 *
 * @param {FriendshipRow} row - The friendship row.
 * @param {"requester" | "recipient"} side - Which of the two to read.
 * @returns {FriendPlayerSource} That player, ready for toFriendPlayer.
 */
const playerOn = (row: FriendshipRow, side: "requester" | "recipient"): FriendPlayerSource => ({
  userid: row[`${side}_userid`],
  username: row[`${side}_username`],
  pic_square: row[`${side}_pic`],
  points: row[`${side}_points`],
  basevalue: row[`${side}_basevalue`],
});

/**
 * The player on the other side of a friendship from whoever is reading it.
 *
 * @param {FriendshipRow} friendship - The friendship row.
 * @param {number} selfId - The player reading their own list.
 * @returns {FriendPlayerSource} The other player, ready for toFriendPlayer.
 */
const otherPlayer = (friendship: FriendshipRow, selfId: number): FriendPlayerSource => {
  const isSelfRequester = friendship.requester_userid === selfId;
  
  if (isSelfRequester) return playerOn(friendship, "recipient");

  return playerOn(friendship, "requester");
};

/**
 * Orders matches by how much of the name the term covers, so the name someone
 * typed outranks longer names that merely contain it. An exact match scores 1
 * and sorts first on its own.
 *
 * @param {string} term - What the player typed.
 * @returns {QueryOrderMap<User>[]} Relevance first, then name, as separate
 * objects because a raw key and a field key cannot share one.
 */
const byRelevance = (term: string): QueryOrderMap<User>[] => [
  { [raw((alias) => `similarity(${alias}.username, ?)`, [term])]: QueryOrder.DESC },
  { username: QueryOrder.ASC },
];

/**
 * How a player relates to the searcher, read off the row the two of them share.
 *
 * @param {RelationRow | undefined} row - Their friendship row, absent when there is none.
 * @param {number} selfId - The player searching.
 * @returns {FriendRelation} The state the launcher labels its button by.
 */
const relationOf = (row: RelationRow | undefined, selfId: number): FriendRelation => {
  if (!row) return FriendRelation.NONE;

  if (row.status === FriendshipStatus.ACCEPTED) return FriendRelation.FRIENDS;

  return row.requester.userid === selfId ? FriendRelation.PENDING_OUTGOING : FriendRelation.PENDING_INCOMING;
};

/**
 * Builds the launcher's Friends page: accepted friends, requests waiting on the
 * player, and requests the player is waiting on. Newest first.
 *
 * @param {User} user - The player whose lists are being read.
 * @returns {Promise<FriendList>} The three lists.
 */
export const getFriendList = async (user: User): Promise<FriendList> => {
  const selfId = user.userid;

  const friendships = await postgres.em
    .createQueryBuilder(Friendship, "friendship")
    .join("friendship.requester", "req")
    .leftJoin("req.save", "reqSave")
    .join("friendship.recipient", "rec")
    .leftJoin("rec.save", "recSave")
    .select([
      "friendship.id",
      "friendship.status",
      "friendship.created_at",
      "friendship.responded_at",
      "req.userid as requester_userid",
      "rec.userid as recipient_userid",
      "req.username as requester_username",
      "req.pic_square as requester_pic",
      "reqSave.points as requester_points",
      "reqSave.basevalue as requester_basevalue",
      "rec.username as recipient_username",
      "rec.pic_square as recipient_pic",
      "recSave.points as recipient_points",
      "recSave.basevalue as recipient_basevalue",
    ])
    .where({ $or: [{ requester: selfId }, { recipient: selfId }] })
    .orderBy({ created_at: QueryOrder.DESC })
    .execute<FriendshipRow[]>("all");

  const lastSeen = await getLastSeen(
    friendships.map((row) => otherPlayer(row, selfId).userid),
    BaseType.MAIN,
  );

  const list: FriendList = { friends: [], incoming: [], outgoing: [] };

  for (const friendship of friendships) {
    const player = toFriendPlayer(otherPlayer(friendship, selfId), lastSeen);

    if (friendship.status === FriendshipStatus.ACCEPTED) {
      list.friends.push({ ...player, since: friendship.responded_at ?? null });
      continue;
    }

    const request = { ...player, request_id: friendship.id, sent_at: friendship.created_at };

    const isOwnedBySelf = friendship.requester_userid === selfId;

    if (isOwnedBySelf) list.outgoing.push(request);
    else list.incoming.push(request);
  }

  list.friends.sort((a, b) => Number(b.online) - Number(a.online) || a.username.localeCompare(b.username));

  return list;
};

/**
 * Finds players by name for the launcher's Find Players tab.
 *
 * Matches anywhere in the name, served by the trigram index on user.username,
 * and ranks the matches by similarity so the name that was typed comes first
 * rather than whichever match happens to sort earliest. An exact match scores
 * 1, so it leads on its own.
 *
 * Leaves out the searcher, banned players, players without a base, and anyone
 * blocked in either direction.
 *
 * @param {User} user - The player searching.
 * @param {string} term - What they typed.
 * @returns {Promise<PlayerSearchResult[]>} Matches with how each relates to the searcher.
 */
export const searchPlayers = async (user: User, term: string): Promise<PlayerSearchResult[]> => {
  const selfId = user.userid;

  const where: FilterQuery<User> = {
    userid: user.blockedUsers.length ? { $ne: selfId, $nin: user.blockedUsers } : { $ne: selfId },
    banned: false,
    save: { $ne: null },
    username: { $ilike: `%${escapeLike(term)}%` },
  };

  const matches = await postgres.em.find(User, where, {
    fields: PLAYER_FIELDS,
    orderBy: byRelevance(term),
    limit: PLAYER_SEARCH_LIMIT,
  });

  const players = matches.filter((player) => !player.blockedUsers.includes(selfId));

  if (players.length === 0) return [];

  const playerIds = players.map((player) => player.userid);

  const [friendships, lastSeen] = await Promise.all([
    postgres.em.find(
      Friendship,
      {
        $or: [
          { requester: selfId, recipient: { $in: playerIds } },
          { recipient: selfId, requester: { $in: playerIds } },
        ],
      },
      { fields: RELATION_FIELDS }
    ),
    getLastSeen(playerIds, BaseType.MAIN),
  ]);

  const friendshipByPlayer = new Map(
    friendships.map((row) => [row.requester.userid === selfId ? row.recipient.userid : row.requester.userid, row])
  );

  return players.map((player) => {
    const row = friendshipByPlayer.get(player.userid);
    const isPending = row?.status === FriendshipStatus.PENDING;

    const source: FriendPlayerSource = {
      userid: player.userid,
      username: player.username,
      pic_square: player.pic_square,
      points: player.save?.points,
      basevalue: player.save?.basevalue,
    };

    return {
      ...toFriendPlayer(source, lastSeen),
      relation: relationOf(row, selfId),
      request_id: isPending ? row.id : null,
    };
  });
};
