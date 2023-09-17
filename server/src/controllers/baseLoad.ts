import { gameConfig } from "../config/GameSettings";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeKeys } from "./keys/generalStore";
import {User} from "../models/user.model";

export const baseLoad: KoaController = async ctx => {
  const baseid = 1234;

  // Try find an already existing save
  logging(`Loading base, user: ${ctx.authUser.username}`)
  const user: User = ctx.authUser
  await ORMContext.em.populate(user, ['save']);
  let save = user.save

  if (save) {
    logging(`Record base load:`, JSON.stringify(save, null, 2));
  } else {
    // There was no existing save, create one with some defaults
    logging(`Record not found, creating a new save`);

    const defaultGameData = {
      baseid,
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
      protectedVal: 1,
      lastupdate: 0,
      usemap: 1,
      homebaseid: 0, // Generate
      credits: 1000,
      champion: "null",
      empiredestroyed: 1,
      worldid: "0", // Generate
      event_score: 0,
      chatenabled: 0,
      relationship: 0,
      error: 0,
      currenttime: 200,
      user,

      // Objects
      buildingdata: {},
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
      updates: [],
      effects: [],
      homebase: [],
      outposts: [],
      worldsize: [500, 500],
      wmstatus: [],
      chatservers: ["bym-chat.kixeye.com"],

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
      over: 0,
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
      attackerchampion: [],
      attackersiege: {},
      purchasecomplete: 0,
      fbpromos: [],
    };

    save = ORMContext.em.create(Save, defaultGameData);

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);

    user.save = save

    // Update user base save
    await ORMContext.em.persistAndFlush(user)
  }

  // Collect the values from the save table
  const {
    type,
    userid,
    wmid,
    createtime,
    savetime,
    seed,
    saveuserid,
    bookmarked,
    fan,
    emailshared,
    unreadmessages,
    giftsentcount,
    id,
    canattack,
    cellid,
    baseid_inferno,
    fbid,
    fortifycellid,
    name,
    level,
    catapult,
    flinger,
    destroyed,
    damage,
    locked,
    points,
    basevalue,
    protectedVal,
    lastupdate,
    usemap,
    homebaseid,
    credits,
    champion,
    empiredestroyed,
    worldid,
    event_score,
    chatenabled,
    relationship,
    currenttime,
    basesaveid,

    // Objects
    buildingdata,
    stats,
    resources,
    lockerdata,
    buildinghealthdata,
    researchdata,
    mushrooms,
    monsterbaiter,
    aiattacks,
    inventory,
    monsters,
    academy,
    loot,
    storedata,
    coords,
    quests,
    player,
    krallen,
    siege,
    buildingresources,

    // Arrays
    updates,
    effects,
    homebase,
    outposts,
    worldsize,
    wmstatus,
    chatservers,
    attacks,
    gifts,
  } = save;

  const storeObject = {
    t: "title_val",
    d: "desc_val",
    c: [0],
    i: "",
    q: 0,
    du: 0,
  };

  const quantities = {};
  storeKeys.forEach((key) => {
    quantities[key] = 100;
  });

  const storeItems = {};
  storeKeys.forEach((key) => {
    if (quantities[key]) {
      storeItems[key] = { ...storeObject, quantity: quantities[key] };
    } else {
      storeItems[key] = { ...storeObject };
    }
  });

  const isTutorialEnabled = gameConfig.skipTutorial ? 205 : 0;

  ctx.status = 200;
  ctx.body = {
    // Constants
    error: 0,
    flags: {
      // Platform
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      gamestats: 0,
      logfps: 0,
      templog: 0,
      gamestatsb: 1,
      split_loadtime: 1,
      split2: 0,
      splituserid2: 15151832,
      split: 0,
      splituserid: 14619212,
      efl: 200,
      sal: 0,
      numchatrooms: 20,
      savedelay: 3,
      fb_api_curl_timeout: 2,
      pageinterval: 25,
      empire_value_limit: 831186222,
      nwm_relocate: 1,
      maproom2: 1,
      attacking: 1,
      gifts: 1,
      maproom: 1,
      attacklog: 1,
      messaging: 1,
      sroverlay: 0,
      leaderboard: 1,
      fanfriendbookmarkquests: 1,
      ticker: 0,
      chat: 2,
      event1: 1,
      event2: 0,
      invasionpop: 6,
      invasionpop2: 6,
      iframestart_override: 0,
      mushrooms: 1,
      chatwhitelist: "2,3,23",
      chatblacklist: 0,
      welcome_email: 1,
      email_reengagement: 1,
      countrycodeblacklist: "ph,my,id",
      radio: 1,
      plinko: 0,
      midgameIncentive: 0,
      showFBCEarn: 1,
      trialpayDealspot: 1,
      showFBCDaily: 0,
      validate_percent: 0,
      autoban_validate_fail: 0,
      autoban_client: 0,
      yp_version: 2,
      ers: 0,
      krallen: 1,
      subscriptions: 1,
      krallen_duration: 7,
      subscriptions_ab: 0,
      subscriptions_ab_admin: 0,
      krallen_award_threshold: 250000000,
      krallen_special1_award_threshold: 750000000,
      krallen_special2_award_threshold: 7000000000,
      saveicon: 1,
      event3start: 1364313600,
      event3end: 1364832000,
      currencystart: 1362168000,
      currencyend: 1362340800,
      updating: 0,
      topups: 1,
      topup_gifts: 1,
      gamedebug: 1,
    },
    basename: "testBase",
    pic_square: "https://apprecs.org/ios/images/app-icons/256/df/634186975.jpg",

    // Primitives
    baseid,
    type,
    userid: user.userid,
    wmid,
    createtime,
    savetime,
    seed,
    saveuserid,
    bookmarked,
    fan,
    emailshared,
    unreadmessages,
    giftsentcount,
    canattack,
    cellid,
    baseid_inferno,
    fbid,
    fortifycellid,
    name,
    level,
    catapult,
    flinger,
    destroyed,
    damage,
    locked,
    points,
    basevalue,
    lastupdate,
    usemap,
    homebaseid,
    credits,
    champion,
    empiredestroyed,
    worldid,
    event_score,
    chatenabled,
    relationship,
    currenttime,
    protected: protectedVal,
    id: basesaveid,
    tutorialstage: isTutorialEnabled,
    storeitems: { ...storeItems },

    // Objects
    buildinghealthdata,
    buildingdata,
    resources,
    aiattacks,
    stats,
    mushrooms,
    monsterbaiter,
    inventory,
    lockerdata,
    storedata,
    monsters,
    academy,
    siege,
    loot,
    buildingresources,
    researchdata,
    coords,
    quests,
    player,
    krallen,
    iresources: resources,

    // Arrays
    homebase,
    updates,
    effects,
    outposts,
    worldsize,
    wmstatus,
    chatservers,
    attacks,
    gifts,

    // Important: 'h' must always be at the end of the payload
    h: "someHashValue",
    hn: 0,
  };
};
