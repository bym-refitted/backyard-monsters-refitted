import { Router, Request, Response } from "express";
import { debugDataLog } from "../middleware/debugDataLog";

const router = Router();

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
      n: "Placeholder name",
      uid: 101, // user ID
      bid: 1234, // base ID
      tid: 0, // wild monster tribe ID
      x: 500, // base x-coord
      y: 500, // base y-coord
      aid: 0,
      l: 0,
      pl: 0,
      r: 0,
      dm: 0,
      rel: 7,
      lo: 0,
      fr: 0,
      p: 0,
      d: 0,
      t: 0,
      fbid: "",
      },
  ],
  h: "someHashValue", 
  });
};

const getNewMap = (res: Response) => {
  res.status(200).json({
    width: 500,
    height: 500,
  });
};

router.get("/worldmapv3/setmapversion/", debugDataLog, (_: any, res: Response) => mapRoomVersion(res));
router.post("/worldmapv3/setmapversion/", debugDataLog, (_: Request, res: Response) => mapRoomVersion(res));

router.get("/worldmapv3/initworldmap/", debugDataLog, (_: any, res: Response) => initMapRoom(res));
router.post("/worldmapv3/initworldmap/", debugDataLog, (_: Request, res: Response) => initMapRoom(res));

router.get("/worldmapv3/getcells/", debugDataLog, (_: any, res: Response) => mapRoomGetCells(res));
router.post("/worldmapv3/getcells/", debugDataLog, (_: Request, res: Response) => mapRoomGetCells(res));

router.get("/api/bm/getnewmap/", debugDataLog, (_: any, res: Response) => getNewMap(res));
router.post("/api/bm/getnewmap/", debugDataLog, (_: Request, res: Response) => getNewMap(res));

  export default router;