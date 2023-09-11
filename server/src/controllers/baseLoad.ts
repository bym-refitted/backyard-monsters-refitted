import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeKeys } from "./keys/generalStore";

export const baseLoad: KoaController = async (ctx) => {
  // get the latest base for userID (0) if it dosnt exist create it - for now its 1234
  // get the latest save id for the base (1234)- if there isnt any in db create it
  const baseid = 1234;
  // Try find an already existing save
  let save = await ORMContext.em.findOne(Save, { baseid });

  if (save) {
    logging(`Record base load:`, JSON.stringify(save, null, 2));
  } else {
    // There was no existing save, create one with some defaults
    logging(`Record not found, creating a new save`);

    // Initialise
    const defaults = {
      basevalue: 20,
      timeplayed: 0,
      flinger: 0,
      catapult: 0,
      version: 128,
      clienttime: 0,
      baseseed: 4520,
      damage: 0,
      healtime: 0,
      points: 5,
      empirevalue: 0,
      baseid,
      stats: {
        popupdata: {},
      },
      resources: {
        r1: 10000,
        r2: 10000,
        r3: 10000,
        r4: 10000,
        r1bonus: 10000,
        r2bonus: 10000,
        r3bonus: 10000,
        r4bonus: 10000,
        r1max: 10000,
        r2max: 10000,
        r3max: 10000,
        r4max: 10000,
      },
      lockerdata: {},
      buildingdata: {},
      mushrooms: {},
      buildinghealthdata: {},
      monsterbaiter: {},
      aiattacks: {},
      inventory: {},
    };

    save = ORMContext.em.create(Save, defaults);

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);
  }

  // Collect the values from the save table
  const {
    baseseed,
    basevalue,
    points,
    basesaveid,
    buildingdata,
    stats,
    resources,
    lockerdata,
    buildinghealthdata,
    mushrooms,
    monsterbaiter,
    aiattacks,
    inventory,
  } = save;

  const storeObject = {
    t: "title_val",
    d: "desc_val",
    c: [0],
    // fbc_cost: [0],
    // i: "",
    // q: 0,
    // du: 0
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

  // Return the base load values
  ctx.status = 200;
  ctx.body = {
    error: 0,
    flags: {
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      midgameIncentive: 0,
      plinko: 0,
      fanfriendbookmarkquests: 0,
      maproom2: 1, // any other value sets the maproom to disabled
    },
    fan: 0,
    protected: 1,
    giftsentcount: 4,
    savetime: 100,
    currenttime: 200,
    id: basesaveid,
    baseseed,
    baseid,
    fbid: 67879,
    userid: 101,
    attackid: 0,
    homebase: false, // This should be an array
    unreadmessages: 0,
    buildinghealthdata,
    buildingdata,
    buildingresources: {},
    resources,
    iresources: resources,
    credits: 2000,
    loot: {},
    researchdata: [],
    stats,
    academy: {},
    siege: {},
    effects: [],
    monsters: {},
    aiattacks,
    tutorialstage: 205, // 205 skips tutorial
    storeitems: { ...storeItems },
    storedata: {},
    inventory,
    lockerdata,
    quests: {},
    monsterbaiter,
    champion: "null",
    attacks: [],
    gifts: [],
    h: "someHashValue",
    basename: "testBase",
    mushrooms,
    name: "John Doe",
    pic_square: "https://apprecs.org/ios/images/app-icons/256/df/634186975.jpg",
    basevalue,
    points,
  };
};
