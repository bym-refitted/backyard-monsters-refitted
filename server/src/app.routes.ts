import Router from "@koa/router";

import { logRequest } from "./middleware/logRequest.js";
import { apiVersion } from "./middleware/apiVersioning.js";
import { verifyUserAuth, verifyAccountStatus } from "./middleware/auth.js";
import { getCellsLimiter, registerLimiter } from "./middleware/rateLimiters.js";
import { Status } from "./enums/StatusCodes.js";

import { init } from "./controllers/init.js";
import { supportedLangs } from "./controllers/supportedLangs.js";

import { login } from "./controllers/auth/login.js";
import { register } from "./controllers/auth/register.js";
import { forgotPassword } from "./controllers/auth/forgotPassword.js";
import { resetPassword } from "./controllers/auth/resetPassword.js";

import { baseLoad } from "./controllers/base/load/baseLoad.js";
import { baseSave } from "./controllers/base/save/baseSave.js";
import { updateSaved } from "./controllers/base/save/updateSaved.js";
import { migrateBase } from "./controllers/maproom/v2/migrateBase.js";

import { getNewMap } from "./controllers/maproom/getNewMap.js";
import { setMapVersion } from "./controllers/maproom/setMapVersion.js";
import { infernoSave } from "./controllers/inferno/infernoSave.js";
import { infernoMonsters } from "./controllers/inferno/infernoMonsters.js";
import { getNeighbours } from "./controllers/maproom/getNeighbours.js";

import { getArea } from "./controllers/maproom/v2/getArea.js";
import { takeoverCell } from "./controllers/maproom/v2/takeoverCell.js";
import { transferMonsters } from "./controllers/maproom/v2/transferMonsters.js";
import { saveBookmarks } from "./controllers/maproom/v2/saveBookmarks.js";

import { initialPlayerCellData } from "./controllers/maproom/v3/initialPlayerCellData.js";
import { getMapRoomCells } from "./controllers/maproom/v3/getCells.js";
import { relocate } from "./controllers/maproom/v3/relocate.js";
import { getFriendInfo } from "./controllers/maproom/v3/getFriendInfo.js";

import { getMessageTargets } from "./controllers/mail/getMessageTargets.js";
import { getMessageThreads } from "./controllers/mail/getMessageThreads.js";
import { getMessageThread } from "./controllers/mail/getMessageThread.js";
import { sendMessage } from "./controllers/mail/sendMessage.js";
import { requestTruce } from "./controllers/mail/requestTruce.js";
import { reportMessageThread } from "./controllers/mail/reportMessageThread.js";

import { getTemplates } from "./controllers/yardplanner/getTemplates.js";
import { saveTemplate } from "./controllers/yardplanner/saveTemplate.js";

import { getAvailableWorlds } from "./controllers/leaderboards/getAvailableWorlds.js";
import { getLeaderboards } from "./controllers/leaderboards/getLeaderboards.js";
import { getAttackLogs } from "./controllers/attacklogs/getAttackLogs.js";

import { wildMonsterInvasion } from "./controllers/events/wildMonsterInvasion.js";
import { recordDebugData } from "./controllers/debug/recordDebugData.js";

const router = new Router();

/**  ────────────────────────────────────────────────
* 📦 General
* ──────────────────────────────────────────────── */
router.post("/init", logRequest, init);
router.get("/connection", (ctx) => (ctx.status = Status.OK));

/**  ────────────────────────────────────────────────
* 📦 Auth
* ──────────────────────────────────────────────── */
router.post("/api/:apiVersion/player/getinfo", apiVersion, logRequest, login);
router.post("/api/:apiVersion/player/register", apiVersion, registerLimiter, logRequest, register);
router.post("/api/:apiVersion/player/forgotPassword", apiVersion, forgotPassword);
router.post("/api/:apiVersion/player/reset-password", resetPassword);
router.get("/api/:apiVersion/supportedLangs", apiVersion, logRequest, supportedLangs);

/**  ────────────────────────────────────────────────
* 📦 Base
* ──────────────────────────────────────────────── */
router.post("/base/load", verifyUserAuth, logRequest, baseLoad);
router.post("/base/save", verifyUserAuth, logRequest, baseSave);
router.post("/base/updatesaved", verifyUserAuth, logRequest, updateSaved);
router.post("/base/migrate", verifyUserAuth, logRequest, migrateBase);

/**  ────────────────────────────────────────────────
* 📦 Map Room 1 / Inferno
* ──────────────────────────────────────────────── */
router.post("/api/:apiVersion/bm/getnewmap", apiVersion, verifyUserAuth, logRequest, getNewMap);
router.post("/api/:apiVersion/bm/base/load", apiVersion, verifyUserAuth, logRequest, baseLoad);
router.post("/api/:apiVersion/bm/base/save", apiVersion, verifyUserAuth, logRequest, infernoSave);
router.post("/api/:apiVersion/bm/base/updatesaved", verifyUserAuth, logRequest, updateSaved);
router.post("/api/:apiVersion/bm/base/infernomonsters", apiVersion, verifyUserAuth, logRequest, infernoMonsters);
router.post("/api/:apiVersion/bm/neighbours/get", apiVersion, verifyUserAuth, logRequest, getNeighbours);

/**  ────────────────────────────────────────────────
* 📦 Map Room 2
* ──────────────────────────────────────────────── */
router.post("/worldmapv2/getarea", verifyUserAuth, verifyAccountStatus, logRequest, getArea);
router.post("/worldmapv2/setmapversion", verifyUserAuth, logRequest, setMapVersion);
router.post("/worldmapv2/takeoverCell", verifyUserAuth, verifyAccountStatus, logRequest, takeoverCell);
router.post("/worldmapv2/transferassets", verifyUserAuth, verifyAccountStatus, logRequest, transferMonsters);
router.post("/api/:apiVersion/player/savebookmarks", apiVersion, verifyUserAuth, verifyAccountStatus, logRequest, saveBookmarks);

/**  ────────────────────────────────────────────────
* 📦 Map Room 3
* ──────────────────────────────────────────────── */
router.post("/worldmapv3/initworldmap", verifyUserAuth, verifyAccountStatus, logRequest, initialPlayerCellData);
router.get("/worldmapv3/initworldmap", verifyUserAuth, verifyAccountStatus, logRequest, initialPlayerCellData);
router.post("/worldmapv3/getcells", verifyUserAuth, verifyAccountStatus, getCellsLimiter, logRequest, getMapRoomCells);
router.get("/worldmapv3/relocate", verifyUserAuth, verifyAccountStatus, logRequest, relocate);
router.get("/worldmapv3/getfriendinfo", verifyUserAuth, verifyAccountStatus, getFriendInfo);
router.get("/worldmapv3/setmapversion", verifyUserAuth, verifyAccountStatus, logRequest, setMapVersion);
router.post("/worldmapv3/setmapversion", verifyUserAuth, verifyAccountStatus, logRequest, setMapVersion);

/**  ────────────────────────────────────────────────
* 📦 Mail
* ──────────────────────────────────────────────── */
router.get("/api/:apiVersion/player/getmessagetargets", apiVersion, verifyUserAuth, logRequest, getMessageTargets);
router.get("/api/:apiVersion/player/getmessagethreads", apiVersion, verifyUserAuth, logRequest, getMessageThreads);
router.post("/api/:apiVersion/player/getmessagethread", apiVersion, verifyUserAuth, logRequest, getMessageThread);
router.post("/api/:apiVersion/player/sendmessage", apiVersion, verifyUserAuth, logRequest, sendMessage);
router.post("/api/:apiVersion/player/requesttruce", apiVersion, verifyUserAuth, logRequest, requestTruce);
router.post("/api/:apiVersion/player/reportmessagethread", apiVersion, verifyUserAuth, logRequest, reportMessageThread);

/**  ────────────────────────────────────────────────
* 📦 Yard Planner
* ──────────────────────────────────────────────── */
router.get("/api/:apiVersion/bm/yardplanner/gettemplates", apiVersion, verifyUserAuth, logRequest, getTemplates);
router.post("/api/:apiVersion/bm/yardplanner/savetemplate", apiVersion, verifyUserAuth, logRequest, saveTemplate);

/**  ────────────────────────────────────────────────
* 📦 Leaderboards & Attack Logs
* ──────────────────────────────────────────────── */
router.get("/api/:apiVersion/worlds", getAvailableWorlds);
router.get("/api/:apiVersion/leaderboards", getLeaderboards);
router.get("/api/:apiVersion/attacklogs", verifyUserAuth, getAttackLogs);

/**  ────────────────────────────────────────────────
* 📦 Events
* ──────────────────────────────────────────────── */
router.get("/api/:apiVersion/events/wmi", apiVersion, logRequest, wildMonsterInvasion);

/**  ────────────────────────────────────────────────
* 📦 Debug
* ──────────────────────────────────────────────── */
router.post("/api/:apiVersion/player/recorddebugdata", apiVersion, recordDebugData);

export default router;