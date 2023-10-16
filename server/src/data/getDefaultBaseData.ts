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
    stats: {
      // Reminder: Remove contents
      mobg: 367720503,
      popupdata: {
        popupStates: [],
        lastDialog: 0,
      },
      mp: 621,
      mob: 632,
      inferno: 0,
      achievements: {
        c: {
          "1": 1,
          "2": 1,
          "3": 1,
          "4": 1,
          "5": 1,
          "22": 1,
          "17": 1,
          "10": 1,
          "15": 1,
        },
        s: {
          alliance: 0,
          unlock_monster: 1,
          stockpile: 1,
          upgrade_champ1: 1,
          UNDERHALL_LEVEL: 0,
          DESCENT_LEVEL: 0,
          upgrade_champ3: 1,
          wm2hall: 1,
          upgrade_champ2: 1,
          hugerage: 0,
          starterkit: 0,
          monstersblended: 632,
          playeroutpost: 0,
          blocksbuilt: 192,
          map2: 0,
          wmoutpost: 0,
          thlevel: 10,
          INFERNO_QUESTS_COMPLETED: 0,
          heavytraps: 1,
        },
      },
      mg: 250,
      moga: 0,
      updateid_mr2: 2,
      updateid: 1063,
      updateid_mr3: 0,
      other: {
        lastKOTHScore: 1417549289,
        p_id: 1,
        pg: 1552861084,
        renewal: 0,
        mutemusic: 1,
        descentLvl: 8,
        pi: 1599323660,
        infernoUpgradeShown: 1,
        CM5: 1599666750,
        underhalLevel: 6,
        expiration: 0,
        mrls: 3,
        s: 1,
        lastLevel: 5,
        CM: 1599666608,
        missionmin: 1,
        lastTime: 1423436568,
        CM3: 1423438080,
        mrl: 3,
        lastKOTHTier: 0,
        chatmin: 1,
        mrlv: 1,
        mute: 1,
        mrlsr: 0,
      },
    },
    academy: {},
    monsterbaiter: {},
    loot: {},
    storedata: {},
    coords: {},
    quests: {},
    resources: {
      r1: 1600,
      r2: 1600,
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
