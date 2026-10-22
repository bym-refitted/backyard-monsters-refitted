import { AttackLogs } from "../../database/models/attacklogs.model.js";
import { Save } from "../../database/models/save.model.js";
import { User } from "../../database/models/user.model.js";
import { BaseType } from "../../enums/Base.js";
import { permissionErr } from "../../errors/errors.js";
import { postgres } from "../../server.js";

/**
 * How long after an attack starts that its saves are accepted (10 minutes).
 * The client's attack timer is up to 7 minutes, plus 2 minutes of overtime
 * before creatures are forced to retreat, plus a margin for lag/loading.
 */
const ATTACK_SAVE_WINDOW_MS = 10 * 60 * 1000;

/**
 * Creates a new attack log entry in the database
 * 
 * Records information about an attack including attacker and defender details,
 * base type, map coordinates, loot obtained, and attack result data.
 * 
 * The log's id becomes the base's attackid, which the client sends back on
 * every attack save so the report can be written into this log.
 *
 * @param {User} attacker - The user who initiated the attack
 * @param {User} defender - The user who was attacked 
 * @param {Save} save - The save data for the attacked base
 * @returns {Promise<void>}
 */
export const createAttackLog = async (attacker: User, defender: User, save: Save) => {
  const attackLog = postgres.em.create(AttackLogs, {
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
    attackreport: "",
    attacktime: new Date(),
  });

  save.lastattackername = attacker.username;

  postgres.em.persist(attackLog);
  await postgres.em.flush();

  save.attackid = attackLog.id;
  await postgres.em.flush();
};

/**
 * Writes the latest attack report into the attack's log.
 *
 * The log is found by the base's attackid and must belong to the attacking user,
 * otherwise the save is rejected.
 *
 * @param {User} attacker - The user sending the attack save
 * @param {Save} save - The save data for the attacked base
 * @param {string | undefined} attackreport - The full report so far, sent by the client
 * @returns {Promise<void>}
 * @throws {permissionErr} If no log matches this attack and attacker
 */
export const updateAttackLog = async (attacker: User, save: Save, attackreport: string | undefined) => {
  if (save.type === BaseType.TRIBE) return;

  const attackLog = await postgres.em.findOne(AttackLogs, {
    id: save.attackid,
    attacker_userid: attacker.userid,
    attacktime: { $gte: new Date(Date.now() - ATTACK_SAVE_WINDOW_MS) },
  });

  if (!attackLog) throw permissionErr();

  if (attackreport !== undefined) attackLog.attackreport = attackreport;
};
