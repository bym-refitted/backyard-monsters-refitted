import { AttackLogs } from "../../models/attacklogs.model";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";

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
    x: save.cell.x,
    y: save.cell.y,

    loot: {},
    attackreport: {},
    attacktime: new Date(),
  });

  await ORMContext.em.persistAndFlush(attackLog);
};