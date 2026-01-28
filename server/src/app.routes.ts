import Router from "@koa/router";

import { logRequest } from "./middleware/logRequest.js";
import { baseSave } from "./controllers/base/save/baseSave.js";
import { login } from "./controllers/auth/login.js";
import { register } from "./controllers/auth/register.js";
import { baseLoad } from "./controllers/base/load/baseLoad.js";
import { updateSaved } from "./controllers/base/save/updateSaved.js";
import { getMapRoomCells } from "./controllers/maproom/v3/getCells.js";
import { getNewMap } from "./controllers/maproom/getNewMap.js";
import { verifyUserAuth, verifyAccountStatus } from "./middleware/auth.js";
import { relocate } from "./controllers/maproom/v3/relocate.js";
import { infernoMonsters } from "./controllers/inferno/infernoMonsters.js";
import { recordDebugData } from "./controllers/debug/recordDebugData.js";
import { getTemplates } from "./controllers/yardplanner/getTemplates.js";
import { saveTemplate } from "./controllers/yardplanner/saveTemplate.js";
import { getArea } from "./controllers/maproom/v2/getArea.js";
import { initialPlayerCellData } from "./controllers/maproom/v3/initialPlayerCellData.js";
import { setMapVersion } from "./controllers/maproom/setMapVersion.js";
import { saveBookmarks } from "./controllers/maproom/v2/saveBookmarks.js";
import { takeoverCell } from "./controllers/maproom/v2/takeoverCell.js";
import { migrateBase } from "./controllers/maproom/v2/migrateBase.js";
import { transferMonsters } from "./controllers/maproom/v2/transferMonsters.js";
import { apiVersion } from "./middleware/apiVersioning.js";
import { supportedLangs } from "./controllers/supportedLangs.js";
import { Status } from "./enums/StatusCodes.js";
import { forgotPassword } from "./controllers/auth/forgotPassword.js";
import { resetPassword } from "./controllers/auth/resetPassword.js";
import { infernoSave } from "./controllers/inferno/infernoSave.js";
import { getNeighbours } from "./controllers/maproom/inferno/getNeighbours.js";
import { Env } from "./enums/Env.js";
import { getMessageTargets } from "./controllers/mail/getMessageTargets.js";
import { getMessageThreads } from "./controllers/mail/getMessageThreads.js";
import { getMessageThread } from "./controllers/mail/getMessageThread.js";
import { sendMessage } from "./controllers/mail/sendMessage.js";
import { reportMessageThread } from "./controllers/mail/reportMessageThread.js";
import type { Context } from "koa";
import { getAvailableWorlds } from "./controllers/leaderboards/getAvailableWorlds.js";
import { getLeaderboards } from "./controllers/leaderboards/getLeaderboards.js";
import { getAttackLogs } from "./controllers/attacklogs/getAttackLogs.js";
import { wildMonsterInvasion } from "./controllers/events/wildMonsterInvasion.js";
import { init } from "./controllers/init.js";
import { RateLimit } from "koa2-ratelimit";

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
router.post("/init", logRequest("Initilizing game client"), init);

/**
 * MapRoom setup
 * @name GET /api/:apiVersion/bm/getnewmap
 */
router.get(
  "/api/:apiVersion/bm/getnewmap",
  apiVersion,
  logRequest("Getting new maproom"),
  getNewMap
);

/**
 * MapRoom setup
 * @name POST /api/:apiVersion/bm/getnewmap
 */
router.post(
  "/api/:apiVersion/bm/getnewmap",
  apiVersion,
  logRequest("Posting to new maproom"),
  getNewMap
);

/**
 * Login route
 * @name POST /api/:apiVersion/player/getinfo
 */
router.post(
  "/api/:apiVersion/player/getinfo",
  apiVersion,
  logRequest("User login attempt"),
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
  logRequest("Registering user"),
  register
);

/**
 * Supported Languages
 * @name GET /api/:apiVersion/supportedLangs
 */
router.get(
  "/api/:apiVersion/supportedLangs",
  apiVersion,
  logRequest("Getting supported languages"),
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
  logRequest("Base load data"),
  baseLoad
);

/**
 * Save base data
 * @name POST /base/save
 */
router.post(
  "/base/save",
  verifyUserAuth,
  logRequest("Base save data"),
  baseSave
);

/**
 * Update saved base data
 * @name POST /base/updatesaved
 */
router.post(
  "/base/updatesaved",
  verifyUserAuth,
  logRequest("Base updated save"),
  updateSaved
);

/**
 * Update Inferno saved base data
 * @name POST /base/updatesaved
 */
router.post(
  "/api/:apiVersion/bm/base/updatesaved",
  verifyUserAuth,
  logRequest("Inferno updated save"),
  updateSaved
);

/**
 * Migrate base data
 * @name POST /base/migrate
 */
router.post(
  "/base/migrate",
  verifyUserAuth,
  logRequest("Base migrate data"),
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
  logRequest("Get templates"),
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
  logRequest("Saving template"),
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
  logRequest("Inferno load data"),
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
  logRequest("Inferno save data"),
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
  logRequest("Getting Inferno neighbours"),
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
  logRequest("Load inferno monsters"),
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
  logRequest("MR2 get area"),
  getArea
);

/**
 * Worldmap v2 set map version
 * @name POST /worldmapv2/setmapversion
 */
router.post(
  "/worldmapv2/setmapversion",
  verifyUserAuth,
  logRequest("Set maproom version"),
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
  logRequest("Taking over cell"),
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
  logRequest("Transferring assets"),
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
  logRequest("MR2 save bookmarks"),
  saveBookmarks
);

/**
 * Worldmap v3 init route
 * @name POST /worldmapv3/initworldmap
 */
router.post(
  "/worldmapv3/initworldmap",
  verifyUserAuth,
  verifyAccountStatus,
  logRequest("Posting MR3 init data"),
  initialPlayerCellData
);

/**
 * Worldmap v3 init route
 * @name GET /worldmapv3/initworldmap
 */
router.get(
  "/worldmapv3/initworldmap",
  verifyUserAuth,
  verifyAccountStatus,
  logRequest("Getting MR3 init data"),
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
  logRequest("Get MR3 cells"),
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
  logRequest("Relocating MR3 base"),
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
  logRequest("Set maproom version"),
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
  logRequest("Set maproom version"),
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
  logRequest("Get message targets"),
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
  logRequest("Get message threads"),
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
  logRequest("Get message thread by threadid"),
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
  logRequest("Send message"),
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
  logRequest("Report message thread"),
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
  logRequest("Getting WMI event details"),
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
