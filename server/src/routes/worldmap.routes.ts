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
  
  const getNewMap = (res: Response) => {
    res.status(200).json({
      error: 0, 
      h: "someHashValue", 
    });
  };
  
  router.get("/worldmapv3/setmapversion/", debugDataLog, (_: any, res: Response) => mapRoomVersion(res));
  router.post("/worldmapv3/setmapversion/", debugDataLog, (_: Request, res: Response) => mapRoomVersion(res));
  
  router.get("/api/bm/getnewmap/", debugDataLog, (_: any, res: Response) => getNewMap(res));
  router.post("/api/bm/getnewmap/", debugDataLog, (_: Request, res: Response) => getNewMap(res));

  export default router;