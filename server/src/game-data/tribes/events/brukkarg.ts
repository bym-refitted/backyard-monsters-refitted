import type { SaveData } from "../../../types/EntityData.js";

const baseDefaults = {
  type: "tribe",
  userid: 0,
  createtime: 0,
  savetime: 0,
  seed: 0,
  saveuserid: 0,
  bookmarked: 0,
  fan: 0,
  emailshared: 1,
  unreadmessages: 0,
  giftsentcount: 0,
  id: 0,
  canattack: false,
  cellid: 0,
  baseid_inferno: 0,
  fbid: "",
  fortifycellid: 0,
  name: "",
  catapult: 0,
  flinger: 0,
  destroyed: 0,
  damage: 0,
  locked: 0,
  protected: 1,
  lastupdate: 0,
  usemap: 0,
  credits: 0,
  champion: [],
  empiredestroyed: 1,
  worldid: "0",
  event_score: 0,
};

/**
 * The Brukkarg War bases, in the order the player attacks them.
 *
 * The client treats any wild monster base whose `wmid` is at or above the first event base
 * id as a Brukkarg base (TRIBES.TribeForBaseID), so these ids sit above every
 * other wild monster id. They stay below 1000, where player base ids begin.
 */
export const brukkargBases: SaveData[] = [
  {
    ...baseDefaults,
    baseid: "901",
    wmid: 901,
    level: 1,
    buildingdata: {
      "0": {
        X: -70,
        Y: 0,
        t: 14,
        id: 0,
      },
    },
  },
  {
    ...baseDefaults,
    baseid: "902",
    wmid: 902,
    level: 2,
    buildingdata: {
      "0": {
        X: -70,
        Y: 0,
        t: 14,
        id: 0,
      },
    },
  },
  {
    ...baseDefaults,
    baseid: "903",
    wmid: 903,
    level: 3,
    buildingdata: {
      "0": {
        X: -70,
        Y: 0,
        t: 14,
        id: 0,
      },
    },
  },
  {
    ...baseDefaults,
    baseid: "904",
    wmid: 904,
    level: 4,
    buildingdata: {
      "0": {
        X: -70,
        Y: 0,
        t: 14,
        id: 0,
      },
    },
  },
];
