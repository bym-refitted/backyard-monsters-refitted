import { clearInterval } from "timers";
import { AttackLogs } from "../../models/attacklogs.model";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { logging, errorLog } from "../../utils/logger";

/**
 * Creates a new attack log entry in the database
 * 
 * Records information about an attack including attacker and defender details,
 * base type, map coordinates, loot obtained, and attack result data.
 * 
 * @param {User} attacker - The user who initiated the attack
 * @param {User} defender - The user who was attacked 
 * @param {Save} save - The save data for the attacked base
 * @returns {Promise<void>}
 */
export const createAttackLog = async (attacker: User, defender: User, save: Save) => {
  const attackLog = ORMContext.em.create(AttackLogs, {
    attacker_userid: attacker.userid,
    attacker_username: attacker.username,
    attacker_pic_square: attacker.pic_square,

    defender_userid: defender.userid,
    defender_username: defender.username,
    defender_pic_square: defender.pic_square,

    type: save.type,
    x: save.cell?.x || null,
    y: save.cell?.y || null,

    loot: {},
    attackreport: {},
    attacktime: new Date(),
  });

  await ORMContext.em.persistAndFlush(attackLog);

  const attackReport = await pollForAttackCompletion(save);
  attackLog.attackreport = {"details": attackReport};
  await ORMContext.em.persistAndFlush(attackLog);
};

/**
 * Polls the save every 2 seconds for attackreport changes.
 * Detects attack completion by monitoring attackid changes.
 */
const pollForAttackCompletion = async (save: Save) => {
  let lastReport = JSON.stringify((await ORMContext.em.findOne(Save, save.basesaveid)).attackreport);
  let lastChangeTime = Date.now();
  let initialAttackId = save.attackid;
  
  const maxDuration = 7 * 60 * 1000; // 7 minutes
  const pollInterval = 1000; // Poll every 1 seconds

  const pollTimer = setInterval(async () => {
    try {
      const freshSave = await ORMContext.em.findOne(Save, save.basesaveid);
      const currentReport = JSON.stringify(freshSave.attackreport || {});
      const currentAttackId = freshSave.attackid;
      const elapsedTime = Date.now() - lastChangeTime;

      logging("current Attack ID:", currentAttackId);
      logging("current Report:" , currentReport);

      // Attack ended: attackid changed to 0
      if (currentAttackId === 0) {
        clearInterval(pollTimer);
        return currentReport;
      }

      // Attack ended and new attack started: attackid changed from initial value to new value
      else if (currentAttackId !== initialAttackId) {
        clearInterval(pollTimer);
        return lastReport;
      }
      // Timeout after 7 minutes = client disconnected 
      else if (elapsedTime > maxDuration) {
        clearInterval(pollTimer);
        return lastReport;
      }
        
      lastReport = currentReport;
      lastChangeTime = Date.now();
    } catch (error) {
      errorLog("Error polling attack completion:", error);
      clearInterval(pollTimer);
    }
  }, pollInterval);
};