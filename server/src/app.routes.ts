import Router from "@koa/router";
import { debugDataLog } from "./middleware/debugDataLog";
import { baseSave } from "./controllers/baseSave";
import { login } from "./controllers/auth/login";
import { register } from "./controllers/auth/register";
import { baseLoad } from "./controllers/baseLoad";
import { updateSaved } from "./controllers/updateSaved";
import {
  initMapRoom,
  mapRoomVersion,
} from "./controllers/maproom/initMapAndVersion";
import { getMapRoomCells } from "./controllers/maproom/getCells";
import { getNewMap } from "./controllers/maproom/getNewMap";
import { auth } from "./middleware/auth";
import { relocate } from "./controllers/maproom/relocate";

interface LogProps {
  logMessage: string;
  debugVars: Object;
}

const router = new Router();

// Auth
router.post("/api/player/getinfo", debugDataLog("User login attempt"), login);
router.post("/api/player/register", debugDataLog("Registering user"), register);

// Save
router.post("/base/save", auth, debugDataLog("Base save data"), baseSave);
router.post(
  "/base/updatesaved",
  debugDataLog("Base updated save"),
  updateSaved
);

// Load
router.post("/base/load", auth, debugDataLog("Base load data"), baseLoad);

// Worldmap
router.post(
  "/worldmapv3/setmapversion",
  debugDataLog("Set maproom version"),
  mapRoomVersion
);
router.post(
  "/worldmapv3/initworldmap",
  debugDataLog("Init maproom data"),
  initMapRoom
);
router.post(
  "/worldmapv3/getcells",
  debugDataLog("Get maproom cells"),
  getMapRoomCells
);

router.post(
  "/worldmapv3/relocate",
  debugDataLog("Relocating base"),
  relocate
);

router.post(
  "/api/bm/getnewmap",
  debugDataLog("Posting to new maproom"),
  getNewMap
);

// Logging routes
// router.post(
//     "/api/player/recorddebugdata",
//     async (ctx: Context) => {
//       logging(`=========== NEW RUN ${randomUUID()} ===========`);
//       const requestLog = ctx.request.body as { message: string };

//       JSON.parse(requestLog.message).forEach((element: LogProps) => {
//         logging(`${element.logMessage}`, element.debugVars);
//       });
//     }
//   );

export default router;
