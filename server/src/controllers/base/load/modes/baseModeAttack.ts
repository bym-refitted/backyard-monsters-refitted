import { BaseMode, BaseType } from "../../../../enums/Base";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { World } from "../../../../models/world.model";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { ORMContext } from "../../../../server";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { wildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";
import { validateRange } from "../../../../services/maproom/v2/validateRange";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../services/maproom/v2/generateMap";
import { AttackLogs } from "../../../../models/attacklogs.model";

export interface AttackDetails {
  fbid: string;
  name: string;
  pic_square: string;
  friend: number;
  count: number;
  starttime: number;
}

export const baseModeAttack = async (user: User, baseid: string) => {
  const userSave: Save = user.save;
  let save = await ORMContext.em.findOne(Save, { baseid });

  if (!save) save = wildMonsterSave(baseid);

  // Store the 100 most recent attacks
  if (save.attacks.length > 3) {
    save.attacks = save.attacks.slice(-2);
  }

  // Track the details of the attack
  const attackDetails: AttackDetails = {
    fbid: userSave.fbid,
    name: user.username,
    pic_square: user.pic_square,
    friend: 0,
    count: 1,
    starttime: getCurrentDateTime(),
  };

  if (save.type != BaseType.TRIBE) save.attacks.push(attackDetails);

  // Remove damage protection
  await damageProtection(userSave, BaseMode.ATTACK);

  let cell = await ORMContext.em.findOne(WorldMapCell, { baseid });

  if (!cell) {
    const world = await ORMContext.em.findOne(World, {
      uuid: userSave.worldid,
    });

    if (!world) throw new Error("No world found.");

    // Derive cellX and cellY from baseid
    const cellX = parseInt(baseid.slice(4, 7));
    const cellY = parseInt(baseid.slice(7, 10));

    const noise = generateNoise(world.uuid);
    const terrainHeight = getTerrainHeight(noise, cellX, cellY);

    // Create a new cell record
    cell = new WorldMapCell(world, cellX, cellY, terrainHeight);
    cell.uid = save.saveuserid;
    cell.base_type = MapRoomCell.WM;
    cell.baseid = baseid;
  }

  save.cell = cell;
  save.worldid = userSave.worldid;
  save.attackid = Math.floor(Math.random() * 99999) + 1;
  await ORMContext.em.persistAndFlush([cell, save]);

  if (save.type !== BaseType.TRIBE) {
    const defender = await ORMContext.em.findOne(User, {
      userid: save.saveuserid,
    });

    if (!defender) throw new Error("Defender user not found.");
    await createAttackLog(user, defender, save);
  }

  return await validateRange(user, save, { baseid });
};

const createAttackLog = async (attacker: User, defender: User, save: Save) => {
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
