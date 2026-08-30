import Router from "@koa/router";

import { logRequest } from "./middleware/logRequest.js";
import { apiVersion } from "./middleware/apiVersioning.js";
import { verifyUserAuth, verifyAccountStatus } from "./middleware/auth.js";
import {
  changeUsernameLimiter,
  getAreaLimiter,
  getCellsLimiter,
  loginLimiter,
  publicReadLimiter,
  registerLimiter,
  allianceInviteLimiter,
  searchAlliancesLimiter,
  snapshotLimiter,
  terrainLimiter,
} from "./middleware/rateLimiters.js";
import { Status } from "./enums/StatusCodes.js";

import { init } from "./controllers/init.js";
import { supportedLangs } from "./controllers/supportedLangs.js";

import { login } from "./controllers/auth/login.js";
import { register } from "./controllers/auth/register.js";
import { forgotPassword } from "./controllers/auth/forgotPassword.js";
import { resetPassword } from "./controllers/auth/resetPassword.js";
import { changeUsername } from "./controllers/auth/changeUsername.js";
import { getAccount } from "./controllers/auth/getAccount.js";

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
import { getSnapshot } from "./controllers/maproom/v2/bulk/getSnapshot.js";
import { getTerrain } from "./controllers/maproom/v2/bulk/getTerrain.js";
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

import { createAlliance } from "./controllers/alliance/createAlliance.js";
import { editAlliance } from "./controllers/alliance/editAlliance.js";
import { leaveAlliance } from "./controllers/alliance/leaveAlliance.js";
import { myAlliance } from "./controllers/alliance/myAlliance.js";
import { searchAlliances } from "./controllers/alliance/searchAlliances.js";
import { myAllianceMembers } from "./controllers/alliance/myAllianceMembers.js";
import { suggestedMembers } from "./controllers/alliance/suggestedMembers.js";
import { requestJoin } from "./controllers/alliance/requestJoin.js";
import { inviteUser } from "./controllers/alliance/inviteUser.js";
import { changeInviteStatus } from "./controllers/alliance/changeInviteStatus.js";
import { getMessages } from "./controllers/alliance/getMessages.js";
import { deleteMessages } from "./controllers/alliance/deleteMessages.js";
import { kickMember } from "./controllers/alliance/kickMember.js";
import { promoteMember } from "./controllers/alliance/promoteMember.js";

const router = new Router();

/**  ────────────────────────────────────────────────
* 📦 General
* ──────────────────────────────────────────────── */
router.post("/init", logRequest, init);
router.get("/connection", (ctx) => (ctx.status = Status.OK));

/**  ────────────────────────────────────────────────
* 📦 Auth
* ──────────────────────────────────────────────── */
router.post("/api/:apiVersion/player/getinfo", apiVersion, loginLimiter, logRequest, login);
router.post("/api/:apiVersion/player/register", apiVersion, registerLimiter, logRequest, register);
router.post("/api/:apiVersion/player/forgotPassword", apiVersion, forgotPassword);
router.post("/api/:apiVersion/player/reset-password", resetPassword);
router.get("/api/:apiVersion/supportedLangs", apiVersion, logRequest, supportedLangs);
router.get("/api/:apiVersion/player/account", apiVersion, verifyUserAuth, getAccount);
router.post("/api/:apiVersion/player/changeusername", apiVersion, verifyUserAuth, changeUsernameLimiter, logRequest, changeUsername);

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
router.post("/worldmapv2/getarea", verifyUserAuth, verifyAccountStatus, getAreaLimiter, logRequest, getArea);
router.get("/worldmapv2/terrain", verifyUserAuth, terrainLimiter, logRequest, getTerrain);
router.get("/worldmapv2/snapshot", verifyUserAuth, snapshotLimiter, logRequest, getSnapshot);
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
router.get("/api/:apiVersion/worlds", publicReadLimiter, getAvailableWorlds);
router.get("/api/:apiVersion/leaderboards", publicReadLimiter, getLeaderboards);
router.get("/api/:apiVersion/attacklogs", verifyUserAuth, getAttackLogs);

/**  ────────────────────────────────────────────────
* 📦 Alliances
* ──────────────────────────────────────────────── */
router.post("/alliance/createalliance", verifyUserAuth, logRequest, createAlliance);
router.post("/alliance/editalliance", verifyUserAuth, logRequest, editAlliance);
router.post("/alliance/leavealliance", verifyUserAuth, logRequest, leaveAlliance);
router.get("/alliance/myalliance", verifyUserAuth, logRequest, myAlliance);
router.get("/alliance/myalliancemembers", verifyUserAuth, logRequest, myAllianceMembers);
router.get("/alliance/getsuggestedmembers", verifyUserAuth, logRequest, suggestedMembers);
router.post("/alliance/searchalliances", verifyUserAuth, searchAlliancesLimiter, logRequest, searchAlliances);
router.post("/alliance/requestjoin", verifyUserAuth, allianceInviteLimiter, logRequest, requestJoin);
router.post("/alliance/inviteuser", verifyUserAuth, allianceInviteLimiter, logRequest, inviteUser);
router.post("/alliance/changeinvitestatus", verifyUserAuth, logRequest, changeInviteStatus);
router.get("/alliance/getmessages", verifyUserAuth, logRequest, getMessages);
router.post("/alliance/deletemessages", verifyUserAuth, logRequest, deleteMessages);
router.post("/alliance/kickmember", verifyUserAuth, logRequest, kickMember);
router.post("/alliance/promotemember", verifyUserAuth, logRequest, promoteMember);

/**  ────────────────────────────────────────────────
* 📦 Events
* ──────────────────────────────────────────────── */
router.get("/api/:apiVersion/events/wmi", apiVersion, logRequest, wildMonsterInvasion);

/**  ────────────────────────────────────────────────
* 📦 Debug
* ──────────────────────────────────────────────── */
router.post("/api/:apiVersion/player/recorddebugdata", apiVersion, recordDebugData);

export default router;