import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";

export interface NeighbourData {
  userid: number;
  baseid: string;
  level: number;
  username: string;
  attacksto?: number;
  attacksfrom?: number;
  helpsto?: number;
  helpsfrom?: number;
  retaliatecount?: number;
  seentime?: number;
  baseseed?: number;
  attacker?: string;
  friend?: number;
  saved?: number;
  attackpermitted?: number;
  basename?: string;
  ownerName?: string;
  pic?: string;
  trucestate?: string;
  truceexpire?: number;
  destroyed?: number;
  online?: boolean;
  description?: string;
  type?: number;
  wm?: number;
}

/**
 * Creates a cached neighbour data object from a save and user.
 *
 * @param {Save} save - The neighbour's save data
 * @param {User} user - The neighbour's user data
 * @param {number} level - The calculated level of the neighbour
 * @returns {NeighbourData} NeighbourData object ready for caching
 */
export const createNeighbourData = (save: Save, user: User, level: number) => {
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
    baseseed: Math.floor(Math.random() * 999999) + 1,
    attacksto: 0,
    attacksfrom: 0,
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
  } as NeighbourData;
};
