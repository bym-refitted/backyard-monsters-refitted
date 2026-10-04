import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { World } from "../../../database/models/world.model.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import { getFriendIds } from "../../friends/friendList.js";
import { postgres } from "../../../server.js";

export interface FriendYard {
  fbid: string;
  pic: string;
  name: string;
  userid: number;
  level: number;
  worldid: number;
  x?: number;
  y?: number;
}

const FRIEND_SAVE_FIELDS = ["userid", "worldid", "points", "basevalue", "cell.x", "cell.y"] as const;

const FRIEND_USER_FIELDS = ["userid", "username", "pic_square"] as const;

/**
 * The number the popup shows as "World N", read out of the world's sector name.
 *
 * @param {string} name - The world's name.
 * @returns {number} Its sector number, or 0 for a world not named that way.
 */
const sectorNumber = (name: string) => Number(name.split("-")[1]) || 0;

/**
 * The player's friends who are in Map Room 3, and where they are.
 *
 * Coordinates are sent only for friends in the same world, because the client decides
 * whether someone shares your world by whether x and y are present rather than by
 * comparing worlds. A friend elsewhere is still listed and can still be moved to; the
 * popup shows their world instead of their position.
 *
 * @param {User} user - The player opening the popup, with their save loaded.
 * @returns {Promise<FriendYard[]>} Their friends' yards, empty when they have none in MR3.
 */
export const getFriendYards = async (user: User): Promise<FriendYard[]> => {
  const friendIds = await getFriendIds(user.userid);

  if (friendIds.size === 0) return [];

  const friendSaves = await postgres.em.find(
    Save,
    {
      userid: { $in: [...friendIds] },
      type: BaseType.MAIN,
      mapversion: MapRoomVersion.V3,
      cell: { $ne: null },
    },
    { fields: FRIEND_SAVE_FIELDS, populate: ["cell"] }
  );

  if (friendSaves.length === 0) return [];

  const [friendUsers, worlds] = await Promise.all([
    postgres.em.find(
      User,
      { userid: { $in: friendSaves.map((save) => save.userid) } },
      { fields: FRIEND_USER_FIELDS }
    ),
    
    postgres.em.find(
      World,
      { uuid: { $in: friendSaves.map((save) => save.worldid).filter(Boolean) as string[] } },
      { fields: ["uuid", "name"] }
    ),
  ]);

  const profiles = new Map(friendUsers.map((friend) => [friend.userid, friend]));
  const sectors = new Map(worlds.map((world) => [world.uuid, sectorNumber(world.name)]));

  const yards: FriendYard[] = [];

  for (const save of friendSaves) {
    const friend = profiles.get(save.userid);

    if (!friend || !save.cell) continue;

    const { userid, worldid, cell, points, basevalue } = save;
    
    const sharesWorld = worldid === user.save?.worldid;

    const yard: FriendYard = {
      fbid: "",
      pic: friend.pic_square ?? "",
      name: friend.username,
      userid,
      level: calculateBaseLevel(points, basevalue),
      worldid: worldid ? sectors.get(worldid) ?? 0 : 0,
      ...(sharesWorld && { x: cell.x, y: cell.y }),
    };

    yards.push(yard);
  }

  return yards;
};
