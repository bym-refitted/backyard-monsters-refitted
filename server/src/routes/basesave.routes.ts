import { Router, Request, Response } from "express";
import { debugDataLog } from "../middleware/debugDataLog";
import { ORMContext } from "../server";
import { Save } from "../models/save.model";

const router = Router();

const baseSaveData = () => (
  {
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

router.get("/base/save/", debugDataLog, (_: any, res: Response) =>res.status(200).json({
  ...baseSaveData,
})
);
router.post(
  "/base/save/",
  debugDataLog,
  async (req: Request, res: Response) => {
    const save = ORMContext.em.create(Save, req.body);
    const saveData = await ORMContext.em.persistAndFlush(save);
    return res.status(200).json({
      ...baseSaveData
    })
  }
);

router.get("/base/updatesaved/", debugDataLog, (_: any, res: Response) =>
  updateSaved(res)
);
router.post("/base/updatesaved/", debugDataLog, (_: Request, res: Response) =>
  updateSaved(res)
);

export default router;
