import Router from "@koa/router";
import { debugDataLog } from "./middleware/debugDataLog";
import { baseSave } from "./controllers/baseSave";
import { login } from "./controllers/auth/login";
import { register } from "./controllers/auth/register";
import { baseLoad } from "./controllers/baseLoad";
import { updateSaved } from "./controllers/updateSaved";
import { getMapRoomCells } from "./controllers/maproom/v3/getCells";
import { getNewMap } from "./controllers/maproom/v3/getNewMap";
import { auth } from "./middleware/auth";
import { relocate } from "./controllers/maproom/v3/relocate";
import { infernoMonsters } from "./controllers/inferno/infernoMonsters";
import { recordDebugData } from "./controllers/debug/recordDebugData";
import { getTemplates } from "./controllers/yardplanner/getTemplates";
import { saveTemplate } from "./controllers/yardplanner/saveTemplate";
import { getArea } from "./controllers/maproom/v2/getArea";
import { initialPlayerCellData } from "./controllers/maproom/v3/initialPlayerCellData";
import { setMapVersion } from "./controllers/maproom/v2/setMapVersion";
import { saveBookmarks } from "./controllers/maproom/v2/saveBookmarks";
import { takeoverCell } from "./controllers/maproom/v2/takeoverCell";
import { migrateBase } from "./controllers/migrateBase";
import { transferAssets } from "./controllers/maproom/v2/transferAssets";
import { apiVersion } from "./middleware/apiVersioning";
import { supportedLangs } from "./controllers/supportedLangs";
import { releasesWebhook } from "./controllers/github/releasesWebhook";
import { STATUS } from "./enums/StatusCodes";

const router = new Router();

// GitHub - Get latest client releases
router.post('/gh-release-webhook', releasesWebhook);

// Init route
router.get("/api/:apiVersion/bm/getnewmap", apiVersion, debugDataLog("Getting new maproom"), getNewMap);
router.post("/api/:apiVersion/bm/getnewmap", apiVersion, debugDataLog("Posting to new maproom"), getNewMap);

// Auth
router.post("/api/:apiVersion/player/getinfo", apiVersion, debugDataLog("User login attempt"), login);
router.post("/api/:apiVersion/player/register", apiVersion, debugDataLog("Registering user"), register);

// Supported Languages
router.get("/api/:apiVersion/supportedLangs", apiVersion, debugDataLog("Getting supported languages"), supportedLangs);

// Load
router.post("/base/load", auth, debugDataLog("Base load data"), baseLoad);

// Save
router.post("/base/save", auth, debugDataLog("Base save data"), baseSave);
router.post("/base/updatesaved", auth, debugDataLog("Base updated save"), updateSaved);
router.post('/base/migrate', auth, debugDataLog("Base migrate data"), migrateBase)

// Yard Planner
router.get("/api/:apiVersion/bm/yardplanner/gettemplates", apiVersion, auth, debugDataLog("Get templates"), getTemplates);
router.post("/api/:apiVersion/bm/yardplanner/savetemplate", apiVersion, auth, debugDataLog("Saving template"), saveTemplate);

// Inferno
router.post("/api/:apiVersion/bm/base/load", apiVersion, auth, debugDataLog("Inferno load data"), baseLoad);
router.post("/api/:apiVersion/bm/base/infernomonsters", apiVersion, auth, debugDataLog("Load inferno monsters"), infernoMonsters);
router.post("/api/:apiVersion/bm/base/save", apiVersion, auth, debugDataLog("Inferno save data"), baseSave);

// Worldmap v2
router.post("/worldmapv2/getarea", auth, debugDataLog("MR2 get area"), getArea);
router.post("/worldmapv2/setmapversion", auth, debugDataLog("Set maproom version"), setMapVersion);
router.post('/worldmapv2/takeoverCell', auth, debugDataLog("Taking over cell"), takeoverCell);
router.post('/worldmapv2/transferassets', auth, debugDataLog("Transferring assets"), transferAssets);
router.post("/api/:apiVersion/player/savebookmarks",apiVersion, auth, debugDataLog("MR2 save bookmarks"), saveBookmarks);

// Worldmap v3
router.post("/worldmapv3/initworldmap", auth, debugDataLog("Posting MR3 init data"), initialPlayerCellData);
router.get("/worldmapv3/initworldmap", auth, debugDataLog("Getting MR3 init data"), initialPlayerCellData);
router.post("/worldmapv3/getcells", auth, debugDataLog("Get MR3 cells"), getMapRoomCells);
router.post("/worldmapv3/relocate", auth, debugDataLog("Relocating MR3 base"), relocate);
router.all("/worldmapv3/setmapversion", auth, debugDataLog("Set maproom version"), setMapVersion);

// Logging routes
router.post("/api/:apiVersion/player/recorddebugdata", apiVersion, recordDebugData);

export default router;
