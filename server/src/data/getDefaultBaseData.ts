import { devConfig } from "../config/DevSettings";
import { User } from "../models/user.model";
import { debugSandbox } from "../dev/debugSandbox";
import { devSandbox } from "../dev/devSandbox";
import { generateID } from "../utils/generateID";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

/**
 * Generates the default base data object for a new save.
 *
 * @param {User} [user] - The user for whom the base data is being generated.
 * @returns {object} - The default base data object.
 */
export const getDefaultBaseData = (user?: User) => {
  // Load sandbox data if dev flags are enabled. View DevSettings.ts for flags & Wiki details.
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
    emailshared: 0,
    unreadmessages: 0,
    giftsentcount: 0,
    id: 0, // Gets set as same value as savetime when save is triggered
    canattack: false,
    cellid: -1,
    baseid_inferno: 0,
    fbid: "",
    fortifycellid: 0,
    name: user.username || "Anonymous",
    level: 1,
    catapult: 0,
    flinger: 0,
    destroyed: 0,
    damage: 0,
    locked: 0,
    points: 0,
    tutorialstage: 0,
    basevalue: 20,
    protected: 0,
    lastupdate: 0,
    usemap: 0,
    homebaseid: baseid,
    credits: devConfig.shiny || 1000,
    champion: "null",
    empiredestroyed: 0,
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
    outposts: [],
    wmstatus: [],
    chatservers: ["bym-chat.kixeye.com"],
    powerups: [], // ToDo: add to DB
    attpowerups: [], // ToDo: add to DB

    // These properties do not get returned in base load, why are they here?
    version: 128,
    baseseed: 0,
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
