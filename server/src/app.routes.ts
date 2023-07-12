import { Router, Request, Response, NextFunction } from "express";
import { errorLog, logging } from "./utils/logger.js";
import { randomUUID } from "crypto";

interface LogProps {
  logMessage: string;
  debugVars: Object;
}

const router = Router();
const baseLoadData = (res: Response) =>
  res.status(200).json({
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
    id: 9765443,
    baseseed: 4520,
    baseid: 1234,
    fbid: 67879,
    userid: 4567,
    attackid: 0,
    homebase: false, // This should be an array
    unreadmessages: 0,
    buildinghealthdata: [],
    buildingdata: {},
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
    basevalue: 20,
    points: 5,
    mushrooms: {},
  });

const baseSaveData = (res: Response) => {
  res.status(200).json({
    error: 0,
    over: 1,
    basesaveid: 1234,
    credits: 2000,
    protected: 1,
    fan: 0,
    bookmarked: 0,
    installsgenerated: 42069,
    resources: {},
    h: "someHashValue",
  });
};

const updateSaved = (res: Response) => {
  res.status(200).json({ 
    error: 0, 
    baseid: 1234,
    version: 128,
    lastupdate: 0,
    type: "build",
    flags: {
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      midgameIncentive: 0,
      plinko: 0,
      fanfriendbookmarkquests: 0,
    },
    h: "someHashValue",
   });
}

const mapRoomVersion = (res: Response) => {
  res.status(200).json({
    error: 0, 
    version: 3, 
    h: "someHashValue", 
  });
};

const initMapRoom = (res: Response) => {
  res.status(200).json({
    error: 0, 
    celldata: [
      {
      x: 500,
      y: 500,
      }
  ],
    h: "someHashValue", 
  });
};

const mapRoomGetCells = (res: Response) => {
  res.status(200).json({
    error: 0, 
    celldata: [
      {
      x: 500,
      y: 500,
      },
  ],
  h: "someHashValue", 
  });
};

const getNewMap = (res: Response) => {
  res.status(200).json({
    width: 500,
    height: 500,
    data: {
      h: 150,
      t: 150
    }
  });
};

// Middleware
const debugDataLog = (req: Request, _: any, next: NextFunction) => {
  logging(`Request body: ${JSON.stringify(req.body)}`);
  next();
};

// Game routes
router.get("/base/load/", debugDataLog, (_: any, res: Response) => baseLoadData(res));
router.post("/base/load/", debugDataLog, (_: Request, res: Response) => baseLoadData(res));

router.get("/base/save/", debugDataLog, (_: any, res: Response) => baseSaveData(res));
router.post("/base/save/", debugDataLog, (_: Request, res: Response) => baseSaveData(res));

router.get("/base/updatesaved/", debugDataLog, (_: any, res: Response) => updateSaved(res));
router.post("/base/updatesaved/", debugDataLog, (_: Request, res: Response) => updateSaved(res));

router.get("/worldmapv3/setmapversion/", debugDataLog, (_: any, res: Response) => mapRoomVersion(res));
router.post("/worldmapv3/setmapversion/", debugDataLog, (_: Request, res: Response) => mapRoomVersion(res));

router.get("/worldmapv3/initworldmap/", debugDataLog, (_: any, res: Response) => initMapRoom(res));
router.post("/worldmapv3/initworldmap/", debugDataLog, (_: Request, res: Response) => initMapRoom(res));

router.get("/worldmapv3/getcells/", debugDataLog, (_: any, res: Response) => mapRoomGetCells(res));
router.post("/worldmapv3/getcells/", debugDataLog, (_: Request, res: Response) => mapRoomGetCells(res));

router.get("/api/bm/getnewmap/", debugDataLog, (_: any, res: Response) => getNewMap(res));
router.post("/api/bm/getnewmap/", debugDataLog, (_: Request, res: Response) => getNewMap(res));

// Logging routes
router.post("/api/player/recorddebugdata/", (req: Request) => {
  logging(`=========== NEW RUN ${randomUUID()} ===========`);
  JSON.parse(req.body.message).forEach((element: LogProps) => {
    logging(`${element.logMessage}`, element.debugVars);
  });
  errorLog(`ERROR: ${req.body.error}`);
});

export default router;