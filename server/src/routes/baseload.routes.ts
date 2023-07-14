import { Router, Request, Response } from "express";
import { debugDataLog } from "../middleware/debugDataLog";
import { ORMContext } from "../server";
import { Save } from "../models/save.model";
import { logging } from "../utils/logger";

const router = Router();

const baseLoadData = async (req: Request, res: Response) => {
  
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
      baseid
    };

    save = ORMContext.em.create(Save, defaults);

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);
  }
  // Collect the values for the response from the save
  const { baseseed, basevalue, points, basesaveid, buildingdata } = save;
  let buildingdataArray = buildingdata || []
 
  // Return the base load values
  return res.status(200).json({
    error: 0,
    flags: {
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      midgameIncentive: 0,
      plinko: 0,
      fanfriendbookmarkquests: 0,
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
    userid: 4567,
    attackid: 0,
    homebase: false, // This should be an array
    unreadmessages: 0,
    buildinghealthdata: [],
    buildingdata: buildingdataArray,
    buildingresources: {},
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
    iresources: {
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
    credits: 2000,
    loot: {},
    researchdata: [],
    stats: {
      popupdata: {},
    },
    academy: {},
    siege: {},
    effects: [],
    monsters: {},
    aiattacks: {},
    tutorialstage: 205, // 205 skips tutorial
    storeitems: {
      BR11I: {
        quantity: 100,
      },
      BR21I: {
        quantity: 100,
      },
      BR31I: {
        quantity: 100,
      },
      BR41I: {
        quantity: 100,
      },
      BR11: {
        quantity: 100,
      },
      BR21: {
        quantity: 100,
      },
      BR31: {
        quantity: 100,
      },
      BR41: {
        quantity: 100,
      },
      BR12I: {
        quantity: 100,
      },
      BR22I: {
        quantity: 100,
      },
      BR32I: {
        quantity: 100,
      },
      BR42I: {
        quantity: 100,
      },
      BR12: {
        quantity: 100,
      },
      BR22: {
        quantity: 100,
      },
      BR32: {
        quantity: 100,
      },
      BR42: {
        quantity: 100,
      },

      BR13I: {
        quantity: 100,
      },
      BR23I: {
        quantity: 100,
      },
      BR33I: {
        quantity: 100,
      },
      BR43I: {
        quantity: 100,
      },
      BR13: {
        quantity: 100,
      },
      BR23: {
        quantity: 100,
      },
      BR33: {
        quantity: 100,
      },
      BR43: {
        quantity: 100,
      },
      FIX: {},
      BLK2: {},
      BLK3: {},
      BLK4: {},
      BLK5: {},
      HOD: {},
      POD: {},
      EXH: {},
    },
    storedata: {},
    inventory: {},
    lockerdata: {},
    quests: {},
    monsterbaiter: {},
    champion: "null",
    attacks: [],
    name: "John Doe",
    pic_square: "https://apprecs.org/ios/images/app-icons/256/df/634186975.jpg",
    gifts: [],
    h: "someHashValue",
    basename: "testBase",
    basevalue,
    points,
    mushrooms: {},
  });
};

router.get("/base/load/", debugDataLog, (req: any, res: Response) =>
  baseLoadData(req, res)
);
router.post("/base/load/", debugDataLog, (req: Request, res: Response) =>
  baseLoadData(req, res)
);

export default router;
