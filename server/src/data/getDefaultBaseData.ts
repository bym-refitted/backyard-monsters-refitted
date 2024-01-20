import { devConfig } from "../config/DevSettings";
import { User } from "../models/user.model";
import { debugSandbox } from "../bases/debugSandbox";
import { devSandbox } from "../bases/devSandbox";
import { generateID } from "../utils/generateID";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

export const getDefaultBaseData = (user?: User) => {
  // These flags allow us to work with debug dev bases
  if (devConfig.devSandbox) return devSandbox;
  if (devConfig.debugSandbox) return debugSandbox;

  return {
    baseid: "0",
    type: "main",
    userid: generateID(8),
    wmid: 0,
    seed: 0,
    saveuserid: 0,
    bookmarked: 0,
    createtime: getCurrentDateTime(),
    savetime: 0, // Updates each time a save is triggered
    fan: 0,
    emailshared: 1,
    unreadmessages: 0,
    giftsentcount: 0,
    id: 0, // Gets set as same value as savetime when save is triggered
    canattack: false,
    cellid: generateID(6),
    baseid_inferno: 0,
    fbid: "100002268912813",
    fortifycellid: 0,
    name: user.username || "Anonymous",
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
    homebaseid: generateID(7, 220),
    credits: 8000,
    champion: "null",
    empiredestroyed: 1,
    worldid: generateID(3, 2).toString(),
    event_score: 0,
    chatenabled: 0,
    relationship: 0,
    error: 0,
    user,

    // Objects
    buildingdata: {},
    buildingkeydata: {},
    buildinghealthdata: {},
    researchdata: {},
    lockerdata: {},
    aiattacks: {},
    mushrooms: {},
    stats: {},
    academy: {},
    monsterbaiter: {},
    loot: {},
    storedata: {},
    coords: {},
    quests: {},
    resources: {
      r1: 0,
      r2: 0,
      r3: 0,
      r4: 0,
      r1max: 10000,
      r2max: 10000,
      r3max: 10000,
      r4max: 10000,
    },
    inventory: {},
    monsters: {},
    player: {},
    krallen: {},
    siege: {},
    buildingresources: {},
    frontpage: {},
    events: {},
    rewards: {
      // Reminder: Remove contents
      spurtzCannonReward2: {
        id: "spurtzCannonReward2",
      },
      spurtzCannonReward: {
        id: "spurtzCannonReward",
      },
      spurtzCannonReward3: {
        id: "spurtzCannonReward3",
      },
    },
    takeover: {},
    iresources: {
      r1: 1600,
      r2: 1600,
      r3: 0,
      r4: 0,
      r1max: 10000,
      r2max: 10000,
      r3max: 10000,
      r4max: 10000,
    },

    // Arrays
    savetemplate: [],
    updates: [],
    effects: [],
    homebase: [],
    outposts: [],
    worldsize: [500, 500],
    wmstatus: [],
    chatservers: ["bym-chat.kixeye.com"],
    powerups: [], // ToDo: add to DB
    attpowerups: [], // ToDo: add to DB

    // These properties do not get rerturned in base load, why are they here?
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
    attackcreatures: {},
    attackloot: {},
    lootreport: {},
    attackerchampion: "null",
    attackersiege: {},
    purchasecomplete: 0,
    fbpromos: [],
  };
};
