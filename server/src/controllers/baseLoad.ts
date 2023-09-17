import { gameConfig } from "../config/GameSettings";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeKeys } from "../keys/generalStore";
import { User } from "../models/user.model";
import { getDefaultBaseData } from "../data/getDefaultBaseData";

export const baseLoad: KoaController = async (ctx) => {
  // Try find an already existing save
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save = user.save;
  logging(`Loading base for user: ${ctx.authUser.username}`);

  if (save) {
    logging(`Base loaded:`, JSON.stringify(save, null, 2));
  } else {
    // There was no existing save, create one with some defaults
    logging(`Base not found, creating a new save`);

    save = ORMContext.em.create(Save, getDefaultBaseData(user));

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);

    user.save = save;

    // Update user base save
    await ORMContext.em.persistAndFlush(user);
  }

  // Collect the values from the save table
  const {
    baseid,
    type,
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
    storeitems: { ...storeItems },

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
