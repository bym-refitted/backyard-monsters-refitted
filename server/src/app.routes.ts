import Router from "@koa/router";

import { debugDataLog } from "./middleware/debugDataLog";
import { baseSave } from "./controllers/base/save/baseSave";
import { login } from "./controllers/auth/login";
import { register } from "./controllers/auth/register";
import { baseLoad } from "./controllers/base/load/baseLoad";
import { updateSaved } from "./controllers/base/save/updateSaved";
import { getMapRoomCells } from "./controllers/maproom/v3/getCells";
import { getNewMap } from "./controllers/maproom/getNewMap";
import { verifyUserAuth, verifyAccountStatus } from "./middleware/auth";
import { relocate } from "./controllers/maproom/v3/relocate";
import { infernoMonsters } from "./controllers/inferno/infernoMonsters";
import { recordDebugData } from "./controllers/debug/recordDebugData";
import { getTemplates } from "./controllers/yardplanner/getTemplates";
import { saveTemplate } from "./controllers/yardplanner/saveTemplate";
import { getArea } from "./controllers/maproom/v2/getArea";
import { initialPlayerCellData } from "./controllers/maproom/v3/initialPlayerCellData";
import { setMapVersion } from "./controllers/maproom/setMapVersion";
import { saveBookmarks } from "./controllers/maproom/v2/saveBookmarks";
import { takeoverCell } from "./controllers/maproom/v2/takeoverCell";
import { migrateBase } from "./controllers/maproom/v2/migrateBase";
import { transferMonsters } from "./controllers/maproom/v2/transferMonsters";
import { apiVersion } from "./middleware/apiVersioning";
import { supportedLangs } from "./controllers/supportedLangs";
import { Status } from "./enums/StatusCodes";
import { forgotPassword } from "./controllers/auth/forgotPassword";
import { resetPassword } from "./controllers/auth/resetPassword";
import { infernoSave } from "./controllers/inferno/infernoSave";
import { getNeighbours } from "./controllers/maproom/inferno/getNeighbours";
import { Env } from "./enums/Env";
import { getMessageTargets } from "./controllers/mail/getMessageTargets";
import { getMessageThreads } from "./controllers/mail/getMessageThreads";
import { getMessageThread } from "./controllers/mail/getMessageThread";
import { sendMessage } from "./controllers/mail/sendMessage";
import { reportMessageThread } from "./controllers/mail/reportMessageThread";
import { Context } from "koa";
import { getAvailableWorlds } from "./controllers/leaderboards/getAvailableWorlds";
import { getLeaderboards } from "./controllers/leaderboards/getLeaderboards";
import { getAttackLogs } from "./controllers/attacklogs/getAttackLogs";
import { wildMonsterInvasion } from "./controllers/events/wildMonsterInvasion";
import { init } from "./controllers/init";

const RateLimit = require("koa2-ratelimit").RateLimit;

/**
 * Rate limit for user registration
 */
const registerLimiter = RateLimit.middleware({
  interval: { min: process.env.ENV === Env.PROD ? 60 : 1 },
  max: 3,
  handler: async (ctx: Context) => {
    ctx.status = Status.TOO_MANY_REQUESTS;
    ctx.body = {
      error:
        "Too many requests where sent from this IP while creating an account. Please try again in 1 hour.",
    };
  },
});

/**
 * Rate limit for leaderboard
 */
const leaderboardLimiter = RateLimit.middleware({
  interval: { min: process.env.ENV === Env.PROD ? 60 : 1 },
  max: 25,
});

/**
 * All applcation routes
 */
const router = new Router();

/**
 * Connection route
 * @name POST /connection
 */
router.get("/connection", (ctx) => (ctx.status = Status.OK));

/**
 * Init route
 * @name GET /api/:apiVersion/bm/getnewmap
 */
router.post("/init", debugDataLog("Initilizing game client"), init);

/**
 * MapRoom setup
 * @name GET /api/:apiVersion/bm/getnewmap
 */
router.get(
  "/api/:apiVersion/bm/getnewmap",
  apiVersion,
  debugDataLog("Getting new maproom"),
  getNewMap
);

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
  registerLimiter,
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
router.post("/api/:apiVersion/player/reset-password", resetPassword);

/**
 * Load base data
 * @name POST /base/load
 */
router.post(
  "/base/load",
  verifyUserAuth,
  debugDataLog("Base load data"),
  baseLoad
);

/**
 * Save base data
 * @name POST /base/save
 */
router.post(
  "/base/save",
  verifyUserAuth,
  debugDataLog("Base save data"),
  baseSave
);

/**
 * Update saved base data
 * @name POST /base/updatesaved
 */
router.post(
  "/base/updatesaved",
  verifyUserAuth,
  debugDataLog("Base updated save"),
  updateSaved
);

/**
 * Update Inferno saved base data
 * @name POST /base/updatesaved
 */
router.post(
  "/api/:apiVersion/bm/base/updatesaved",
  verifyUserAuth,
  debugDataLog("Inferno updated save"),
  updateSaved
);

/**
 * Migrate base data
 * @name POST /base/migrate
 */
router.post(
  "/base/migrate",
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
  debugDataLog("Inferno save data"),
  infernoSave
);

/**
 * Inferno get MapRoom neighbours
 * @name POST /api/:apiVersion/bm/neighbours/get
 */
router.post(
  "/api/:apiVersion/bm/neighbours/get",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Getting Inferno neighbours"),
  getNeighbours
);

/**
 * Inferno load monsters data
 * @name POST /api/:apiVersion/bm/base/infernomonsters
 */
router.post(
  "/api/:apiVersion/bm/base/infernomonsters",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Load inferno monsters"),
  infernoMonsters
);

/**
 * Worldmap v2 get area data
 * @name POST /worldmapv2/getarea
 */
router.post(
  "/worldmapv2/getarea",
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
  debugDataLog("Taking over cell"),
  takeoverCell
);

/**
 * Worldmap v2 transfer assets
 * @name POST /worldmapv2/transferassets
 */
router.post(
  "/worldmapv2/transferassets",
  verifyUserAuth,
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
  verifyUserAuth,
  verifyAccountStatus,
  debugDataLog("MR2 save bookmarks"),
  saveBookmarks
);


/**
 * Worldmap v3 init route
 * @name GET /worldmapv3/initworldmap
 */
router.get(
  "/worldmapv3/initworldmap",
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
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
  verifyUserAuth,
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

/**
 * Get other user's data for message
 * @name GET /api/:apiVersion/player/getmessagetargets
 */
router.get(
  "/api/:apiVersion/player/getmessagetargets",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Get message targets"),
  getMessageTargets
);

/**
 * Get message threads of current user
 * @name GET /api/:apiVersion/player/getmessagethreads
 */
router.get(
  "/api/:apiVersion/player/getmessagethreads",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Get message threads"),
  getMessageThreads
);

/**
 * Get messages by thread id, and update the unread value
 * @name POST /api/:apiVersion/player/getmessagethread
 */
router.post(
  "/api/:apiVersion/player/getmessagethread",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Get message thread by threadid"),
  getMessageThread
);

/**
 * Send message
 * @name POST /api/:apiVersion/player/sendmessage
 */
router.post(
  "/api/:apiVersion/player/sendmessage",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Send message"),
  sendMessage
);

/**
 * Report thread
 * @name POST /api/:apiVersion/player/reportmessagethread
 */
router.post(
  "/api/:apiVersion/player/reportmessagethread",
  apiVersion,
  verifyUserAuth,
  debugDataLog("Report message thread"),
  reportMessageThread
);

/**
 * Get WMI1 event details
 * @name GET /api/:apiVersion/events/wmi1
 */
router.get(
  "/api/:apiVersion/events/wmi",
  apiVersion,
  // verifyUserAuth,
  debugDataLog("Getting WMI event details"),
  wildMonsterInvasion
);

/**
 * Get available worlds
 * @name GET /api/worlds
 */
router.get("/api/:apiVersion/worlds", getAvailableWorlds);

/**
 * Get leaderboards
 * @name GET /api/leaderboards
 */
router.get("/api/:apiVersion/leaderboards", getLeaderboards);

/**
 * Get attack logs
 * @name GET /api/attacklogs
 */
router.get("/api/:apiVersion/attacklogs", verifyUserAuth, getAttackLogs);

export default router;
