import { Router, Request, Response } from "express";
import { debugDataLog } from "../middleware/debugDataLog";
import { ORMContext } from "../server";
import { Save } from "../models/save.model";
import { logging } from "../utils/logger";

const router = Router();

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
};

router.post(
  "/base/save/",
  debugDataLog("Base save data"),
  async (req: Request, res: Response) => {
    logging(`Saving the base!`);
    let save = await ORMContext.em.findOne(Save, {
      basesaveid: req.body.basesaveid,
    });

    // update the save with the values from the request
    for (const key of Save.jsonKeys) {
      req.body[key] = JSON.parse(req.body[key]);
    }
    // Equivalent to Object.assign() - merges second object onto entity
    ORMContext.em.assign(save, req.body);
    // Execute the update in the db
    await ORMContext.em.persistAndFlush(save);

    // hardcoded for now
    const baseSaveData = {
      error: 0,
      over: 1,
      basesaveid: req.body.basesaveid,
      credits: 2000,
      protected: 1,
      fan: 0,
      bookmarked: 0,
      installsgenerated: 42069,
      resources: {},
      h: "someHashValue",
    };
    return res.status(200).json({ ...baseSaveData });
  }
);

router.get("/base/updatesaved/", debugDataLog(), (_: any, res: Response) =>
  updateSaved(res)
);
router.post(
  "/base/updatesaved/",
  debugDataLog("Base updated save"),
  (_: Request, res: Response) => updateSaved(res)
);

export default router;
