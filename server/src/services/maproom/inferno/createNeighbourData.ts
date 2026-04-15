import { User } from "../../../models/user.model.js";
import { Save } from "../../../models/save.model.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";

/**
 * Creates a cached neighbour data object from a save and user.
 *
 * @param {Save} save - The neighbour's save data
 * @param {User} user - The neighbour's user data
 * @param {number} level - The calculated level of the neighbour
 * @returns {NeighbourData} NeighbourData object ready for caching
 */
export const createNeighbourData = (save: Save, user: User, level: number): NeighbourData => {
  const timestamp = Math.floor(save.lastupdateAt.getTime() / 1000);

  return {
    userid: save.userid,
    baseid: save.baseid,
    username: user.username,
    basename: user.username,
    ownerName: user.username,
    pic: user.pic_square || "",
    saved: timestamp,
    seentime: timestamp,
    baseseed: save.userid, 
    attacksto: 0,
    attacksfrom: 0,
    attacksTodayCount: 0,
    attacksTodayDate: Math.floor(new Date().setHours(0, 0, 0, 0) / 1000),
    helpsto: 0,
    helpsfrom: 0,
    retaliatecount: 0,
    attacker: "",
    friend: 0,
    attackpermitted: 1,
    type: 0,
    wm: 0,
    trucestate: "",
    truceexpire: 0,
    destroyed: 0,
    online: false,
    description: "",
    level,
  }
};
