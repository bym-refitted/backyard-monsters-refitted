import { Router, Response } from "express";

const router = Router();

const resGetter = (res: Response) =>
  res.status(200).json({
    error: 0,
    flags: [],
    fan: 0,
    protected: 1,
    giftsentcount: 4,
    savetime: 100,
    currenttime: 200,
    id: 9765443,
    baseseed: 4520,
    baseid: 1,
    fbid: 67879,
    userid: 4567,
    attackid: 0,
    homebase: true,
    unreadmessages: 0,
    buildinghealthdata: {},
    buildingdata: {},
    buildingresources: {},
    resources: {},
    credits: 250,
    loot: {},
    researchdata: [],
    stats: {},
    academy: {},
    siege: {},
    effects: {},
    monsters: {},
    aiattacks: {},
    tutorialstage: 0,
    storeitems: {},
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
  });

router.get("/base/load/", (_: any, res: Response) => resGetter(res));
router.post("/base/load/", (_: any, res: Response) => resGetter(res));

router.get("/api/", (_: any, res: Response) =>
  res.status(200).json({
    error: 0,
  })
);

export default router;
