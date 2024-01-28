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
import { infernoMonsters } from "./controllers/inferno/infernoMonsters";
import { recordDebugData } from "./controllers/debug/recordDebugData";
import { getTemplates } from "./controllers/yardplanner/getTemplates";
import { saveTemplate } from "./controllers/yardplanner/saveTemplate";
import {RateLimit}  from "koa2-ratelimit"
const router = new Router();

// Init route
router.get("/api/bm/getnewmap", debugDataLog("Posting to new maproom"), getNewMap);
router.post("/api/bm/getnewmap", debugDataLog("Posting to new maproom"), getNewMap);

const getUserLimiter = RateLimit.middleware({
  interval: 60*1000, // 15 minutes
  max: 30, 
});

// Auth
router.post("/api/player/getinfo", getUserLimiter, debugDataLog("User login attempt"), login);
router.post("/api/player/register", debugDataLog("Registering user"), register);

// Load
router.post("/base/load", auth, debugDataLog("Base load data"), baseLoad);

// Save
router.post("/base/save", auth, debugDataLog("Base save data"), baseSave);
router.post("/base/updatesaved", auth, debugDataLog("Base updated save"), updateSaved);

// Yard Planner
router.get("/api/bm/yardplanner/gettemplates", auth, debugDataLog("Get templates"), getTemplates);
router.post("/api/bm/yardplanner/savetemplate", auth, debugDataLog("Saving template"), saveTemplate);

// Inferno
router.post("/api/bm/base/load", auth, debugDataLog("Inferno load data"), baseLoad);
router.post("/api/bm/base/infernomonsters", auth, debugDataLog("Load inferno monsters"), infernoMonsters);
router.post("/api/bm/base/save", auth, debugDataLog("Inferno save data"), baseSave);

// Worldmap
router.post("/worldmapv3/setmapversion", auth, debugDataLog("Set maproom version"), mapRoomVersion);
router.post("/worldmapv3/initworldmap", auth, debugDataLog("Init maproom data"), initMapRoom);
router.post("/worldmapv3/getcells", auth, debugDataLog("Get maproom cells"), getMapRoomCells);
router.post("/worldmapv3/relocate", auth, debugDataLog("Relocating base"), relocate);

// Logging routes
router.post("/api/player/recorddebugdata", recordDebugData);

export default router;
