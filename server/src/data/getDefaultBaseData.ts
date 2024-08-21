import { devConfig } from "../config/DevSettings";
import { User } from "../models/user.model";
import { debugSandbox } from "../bases/debugSandbox";
import { devSandbox } from "../bases/devSandbox";
import { generateID } from "../utils/generateID";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

export const getDefaultBaseData = (user?: User) => {
  // These flags allow us to work with debug dev bases
  if (devConfig.devSandbox) return devSandbox(user);
  if (devConfig.debugSandbox) return debugSandbox(user);

  const baseid = generateID(9);

  return {
    baseid: baseid.toString(10),
    type: "main",
    userid: generateID(8),
    wmid: 0,
    seed: 0,
    saveuserid: user.userid,
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
    protected: 0,
    lastupdate: 0,
    usemap: 0,
    homebaseid: baseid,
    credits: process.env.SHINY ? parseInt(process.env.SHINY) : 2500,
    champion: "null",
    empiredestroyed: 1,
    worldid: "",
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
    coords: { x: 0, y: 0 }, // Check this
    quests: {},
    resources: {
      r1: 78400,
      r2: 78400,
      r3: 80000,
      r4: 80000,
      r1max: 10000,
      r2max: 10000,
      r3max: 10000,
      r4max: 10000,
    },
    inventory: {},
    monsters: {},
    player: {},
    krallen: devConfig.unlockAllEventRewards
      ? {
          countdown: 443189,
          wins: 5,
          tier: 5,
          loot: 750000000000,
        }
      : {},
    siege: {},
    buildingresources: {},
    frontpage: {},
    events: {},
    rewards: devConfig.unlockAllEventRewards
      ? {
          // Unique event reward unlockables
          spurtzCannonReward2: { id: "spurtzCannonReward2" },
          spurtzCannonReward: { id: "spurtzCannonReward" },
          spurtzCannonReward3: { id: "spurtzCannonReward3" },
          unlockRezghul: { id: "unlockRezghul" },
          unblockSlimeattikus: { id: "unblockSlimeattikus" },
          unblockVorg: { id: "unblockVorg" },
          KorathReward: { id: "KorathReward", value: 3 },
          krallenReward: { id: "krallenReward", value: 1 },
        }
      : {},
    takeover: {},
    iresources: {
      r1: 0,
      r2: 0,
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
    homebase: null,
    outposts: null,
    // worldsize: [800, 800],
    wmstatus: [],
    chatservers: ["bym-chat.kixeye.com"],
    powerups: [], // ToDo: add to DB
    attpowerups: [], // ToDo: add to DB

    // These properties do not get returned in base load, why are they here?
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
