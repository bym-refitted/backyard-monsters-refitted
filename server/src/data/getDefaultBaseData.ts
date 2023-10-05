import { gameConfig } from "../config/GameSettings";
import { User } from "../models/user.model";
import { endGameBase } from "../sample/endGameBase";
import { midGameBase } from "../sample/midGameBase";

const currentTimeInSeconds: number = Math.floor(new Date().getTime() / 1000);

export const getDefaultBaseData = (user?: User) => {
  // This allows us to work with example bases
  // Which are at the half-way and end-game mark in terms of progress.
  if (gameConfig.loadFinishedBase) return endGameBase;
  if (gameConfig.loadMidBase) return midGameBase;

  return {
    baseid: "0",
    type: "main",
    userid: 101, // Generate
    wmid: 0,
    createtime: 0,
    savetime: 0,
    seed: 0,
    saveuserid: 0,
    bookmarked: 0,
    fan: 0,
    emailshared: 1,
    unreadmessages: 0,
    giftsentcount: 0,
    id: 0, // Generate
    canattack: false,
    cellid: 0, // Generate
    baseid_inferno: 0,
    fbid: "67879",
    fortifycellid: 0,
    name: "name",
    level: 1,
    catapult: 0,
    flinger: 0,
    destroyed: 0,
    damage: 0,
    locked: 0,
    points: 5,
    basevalue: 20,
    protected: 1,
    lastupdate: 0,
    usemap: 1,
    homebaseid: 0, // Generate
    credits: 2000,
    champion: "null",
    empiredestroyed: 1,
    worldid: "0", // Generate
    event_score: 0,
    chatenabled: 0,
    relationship: 0,
    error: 0,
    currenttime: currentTimeInSeconds,
    user,

    // Objects
    buildingdata: {},
    buildingkeydata: {},
    buildinghealthdata: {},
    researchdata: {},
    lockerdata: {},
    aiattacks: {},
    mushrooms: {},
    stats: { popupdata: {} },
    academy: {},
    monsterbaiter: {},
    loot: {},
    storedata: {},
    coords: {},
    quests: {},
    resources: {
      r2: 1600,
      r2max: 10000,
      r1max: 10000,
      r1: 1600,
      r4max: 10000,
      r3max: 10000,
      r3: 0,
      r4: 0,
    },
    inventory: {},
    monsters: {},
    player: {},
    krallen: {},
    siege: {},
    buildingresources: {},
    frontpage: {},
    events: {},
    rewards: {},
    takeover: {},
    iresources: {
      r2: 1600,
      r4: 0,
      r1: 1600,
      r3: 0,
      r3max: 10000,
      r2max: 10000,
      r1max: 10000,
      r4max: 10000,
    },

    // Arrays
    updates: [], // Important: is this [] or "[]"
    effects: [],
    homebase: [],
    outposts: [],
    worldsize: [500, 500],
    wmstatus: [],
    chatservers: ["bym-chat.kixeye.com"],
    powerups: [], // ToDo: add to DB
    attpowerups: [], // ToDo: add to DB

    // Client saves | not returned
    version: 128,
    baseseed: 4520,
    healtime: 0,
    empirevalue: 0,
    clienttime: 0,
    timeplayed: 0,
    achieved: [],
    monsterupdate: {},
    basename: "basename",
    attackreport: "",
    over: 1,
    protect: 0,
    attackid: 0,
    attacks: [],
    gifts: [],
    sentinvites: [],
    sentgifts: [],
    purchase: {},
    attackcreatures: {},
    attackloot: {},
    lootreport: {},
    attackerchampion: "null", // []
    attackersiege: {},
    purchasecomplete: 0,
    fbpromos: [],
  };
};
