import Router from "@koa/router";
import { debugDataLog } from "./middleware/debugDataLog";
import { baseSave } from "./controllers/base/save/baseSave";
import { login } from "./controllers/auth/login";
import { register } from "./controllers/auth/register";
import { baseLoad } from "./controllers/base/load/baseLoad";
import { updateSaved } from "./controllers/base/save/updateSaved";
import { getMapRoomCells } from "./controllers/maproom/v3/getCells";
import { getNewMap } from "./controllers/maproom/getNewMap";
import { auth, verifyAccountStatus } from "./middleware/auth";
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
import { migrateBase } from "./controllers/maproom/v2/migrateBase";
import { transferMonsters } from "./controllers/maproom/v2/transferMonsters";
import { apiVersion } from "./middleware/apiVersioning";
import { supportedLangs } from "./controllers/supportedLangs";
import { releasesWebhook } from "./controllers/github/releasesWebhook";
import { Status } from "./enums/StatusCodes";
import { forgotPassword } from "./controllers/auth/forgotPassword";
import { resetPassword } from "./controllers/auth/resetPassword";
import { devConfig } from "./config/DevSettings";

/**
 * All applcation routes
 */
const router = new Router();

/**
 * GitHub - Get latest client releases
 * @name POST /gh-release-webhook
 */
router.post("/gh-release-webhook", releasesWebhook);

/**
 * Connection route
 * @name POST /connection
 */
router.get("/connection", (ctx) => (ctx.status = Status.OK));

/**
 * Init route
 * @name GET /api/:apiVersion/bm/getnewmap
 */
router.post("/init", debugDataLog("Initilizing game client"), (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { debugMode: devConfig.debugMode };
});

/**
 * MapRoom setup
 * @name POST /api/:apiVersion/bm/getnewmap
 */
router.post(
  "/api/:apiVersion/bm/getnewmap",
  apiVersion,
  debugDataLog("Posting to new maproom"),
  getNewMap
);

/**
 * Login route
 * @name POST /api/:apiVersion/player/getinfo
 */
router.post(
  "/api/:apiVersion/player/getinfo",
  apiVersion,
  debugDataLog("User login attempt"),
  login
);

/**
 * Register route
 * @name POST /api/:apiVersion/player/register
 */
router.post(
  "/api/:apiVersion/player/register",
  apiVersion,
  debugDataLog("Registering user"),
  register
);

/**
 * Supported Languages
 * @name GET /api/:apiVersion/supportedLangs
 */
router.get(
  "/api/:apiVersion/supportedLangs",
  apiVersion,
  debugDataLog("Getting supported languages"),
  supportedLangs
);

/**
 * Forgot password
 * @name POST /player/forgotpassword
 */
router.post(
  "/api/:apiVersion/player/forgotPassword",
  apiVersion,
  forgotPassword
);

/**
 * Reset password
 * @name POST /player/reset-password
 */
router.post("/api/player/reset-password", resetPassword);

/**
 * Load base data
 * @name POST /base/load
 */
router.post("/base/load", auth, debugDataLog("Base load data"), baseLoad);

/**
 * Save base data
 * @name POST /base/save
 */
router.post("/base/save", auth, debugDataLog("Base save data"), baseSave);

/**
 * Update saved base data
 * @name POST /base/updatesaved
 */
router.post(
  "/base/updatesaved",
  auth,
  debugDataLog("Base updated save"),
  updateSaved
);

/**
 * Migrate base data
 * @name POST /base/migrate
 */
router.post(
  "/base/migrate",
  auth,
  debugDataLog("Base migrate data"),
  migrateBase
);

/**
 * Yard Planner retrieve templates
 * @name GET /api/:apiVersion/bm/yardplanner/gettemplates
 */
router.get(
  "/api/:apiVersion/bm/yardplanner/gettemplates",
  apiVersion,
  auth,
  debugDataLog("Get templates"),
  getTemplates
);

/**
 * Yard Planner save template
 * @name POST /api/:apiVersion/bm/yardplanner/savetemplate
 */
router.post(
  "/api/:apiVersion/bm/yardplanner/savetemplate",
  apiVersion,
  auth,
  debugDataLog("Saving template"),
  saveTemplate
);

/**
 * Inferno load base data
 * @name POST /api/:apiVersion/bm/base/load
 */
router.post(
  "/api/:apiVersion/bm/base/load",
  apiVersion,
  auth,
  debugDataLog("Inferno load data"),
  baseLoad
);

/**
 * Inferno save base data
 * @name POST /api/:apiVersion/bm/base/save
 */
router.post(
  "/api/:apiVersion/bm/base/save",
  apiVersion,
  auth,
  debugDataLog("Inferno save data"),
  baseSave
);

/**
 * Inferno load monsters data
 * @name POST /api/:apiVersion/bm/base/infernomonsters
 */
router.post(
  "/api/:apiVersion/bm/base/infernomonsters",
  apiVersion,
  auth,
  debugDataLog("Load inferno monsters"),
  infernoMonsters
);

/**
 * Worldmap v2 get area data
 * @name POST /worldmapv2/getarea
 */
router.post(
  "/worldmapv2/getarea",
  auth,
  verifyAccountStatus,
  debugDataLog("MR2 get area"),
  getArea
);

/**
 * Worldmap v2 set map version
 * @name POST /worldmapv2/setmapversion
 */
router.post(
  "/worldmapv2/setmapversion",
  auth,
  verifyAccountStatus,
  debugDataLog("Set maproom version"),
  setMapVersion
);

/**
 * Worldmap v2 takeover cell
 * @name POST /worldmapv2/takeoverCell
 */
router.post(
  "/worldmapv2/takeoverCell",
  verifyAccountStatus,
  auth,
  debugDataLog("Taking over cell"),
  takeoverCell
);

/**
 * Worldmap v2 transfer assets
 * @name POST /worldmapv2/transferassets
 */
router.post(
  "/worldmapv2/transferassets",
  auth,
  verifyAccountStatus,
  debugDataLog("Transferring assets"),
  transferMonsters
);

/**
 * Worldmap v2 save bookmarks
 * @name POST /api/:apiVersion/player/savebookmarks
 */
router.post(
  "/api/:apiVersion/player/savebookmarks",
  apiVersion,
  auth,
  verifyAccountStatus,
  debugDataLog("MR2 save bookmarks"),
  saveBookmarks
);

/**
 * Worldmap v3 init route
 * @name POST /worldmapv3/initworldmap
 */
router.post(
  "/worldmapv3/initworldmap",
  auth,
  verifyAccountStatus,
  debugDataLog("Posting MR3 init data"),
  initialPlayerCellData
);

/**
 * Worldmap v3 init route
 * @name GET /worldmapv3/initworldmap
 */
router.get(
  "/worldmapv3/initworldmap",
  auth,
  verifyAccountStatus,
  debugDataLog("Getting MR3 init data"),
  initialPlayerCellData
);

/**
 * Worldmap v3 get cells
 * @name POST /worldmapv3/getcells
 */
router.post(
  "/worldmapv3/getcells",
  auth,
  verifyAccountStatus,
  debugDataLog("Get MR3 cells"),
  getMapRoomCells
);

/**
 * Worldmap v3 relocate base
 * @name POST /worldmapv3/relocate
 */
router.post(
  "/worldmapv3/relocate",
  auth,
  verifyAccountStatus,
  debugDataLog("Relocating MR3 base"),
  relocate
);

/**
 * Worldmap v3 set map version
 * @name GET /worldmapv3/setmapversion
 */
router.get(
  "/worldmapv3/setmapversion",
  auth,
  verifyAccountStatus,
  debugDataLog("Set maproom version"),
  setMapVersion
);

/**
 * Worldmap v3 set map version
 * @name POST /worldmapv3/setmapversion
 */
router.post(
  "/worldmapv3/setmapversion",
  auth,
  verifyAccountStatus,
  debugDataLog("Set maproom version"),
  setMapVersion
);

/**
 * Logging routes
 * @name POST /api/:apiVersion/player/recorddebugdata
 */
router.post(
  "/api/:apiVersion/player/recorddebugdata",
  apiVersion,
  recordDebugData
);

export default router;
