import { BaseMode, BaseType } from "../../../../enums/Base.js";
import { MapRoomCell, MapRoomVersion } from "../../../../enums/MapRoom.js";
import { World } from "../../../../models/world.model.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { postgres } from "../../../../server.js";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { tribeSaveHandler } from "../../../../services/maproom/tribeSaveHandler.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import { validateRange } from "../../../../services/maproom/v2/validateRange.js";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../services/maproom/v2/generateMap.js";
import { createAttackLog } from "../../../../services/base/createAttackLog.js";

export interface AttackDetails {
  fbid: string;
  name: string;
  pic_square: string;
  friend: number;
  count: number;
  starttime: number;
  seen: boolean;
}

/**
 * Processes an attack from a user against a specific base
 * 
 * @param {User} user - The attacking user
 * @param {string} baseid - ID of the base being attacked
 * @param {MapRoomVersion} mapversion - Version of the map room being used
 * @returns Result of range validation check
 */
export const baseModeAttack = async (user: User, baseid: string, mapversion: MapRoomVersion) => {
  const userSave: Save = user.save;
  let save = await postgres.em.findOne(Save, { baseid });

  if (!save) save = tribeSaveHandler(baseid, mapversion);

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
    seen: false,
  };

  if (save.type != BaseType.TRIBE) save.attacks.push(attackDetails);

  await damageProtection(userSave, BaseMode.ATTACK);

  let cell = await postgres.em.findOne(WorldMapCell, { baseid });

  if (!cell) {
    const cellX = parseInt(baseid.slice(-6, -3));
    const cellY = parseInt(baseid.slice(-3));

    const world = await postgres.em.findOne(World, { uuid: userSave.worldid });

    if (!world) throw new Error("No world found.");

    if (mapversion === MapRoomVersion.V3) {
      cell = new WorldMapCell(world, cellX, cellY, 0);
      cell.uid = save.saveuserid;
      cell.base_type = save.wmid;
      cell.map_version = MapRoomVersion.V3;
      cell.baseid = baseid;
    } else {
      const noise = generateNoise(world.uuid);
      const terrainHeight = getTerrainHeight(noise, cellX, cellY);

      cell = new WorldMapCell(world, cellX, cellY, terrainHeight);
      cell.uid = save.saveuserid;
      cell.base_type = MapRoomCell.WM;
      cell.map_version = MapRoomVersion.V2;
      cell.baseid = baseid;
    }
  }

  save.cell = cell;
  save.worldid = userSave.worldid;
  save.attackid = Math.floor(Math.random() * 99999) + 1;
  await postgres.em.persistAndFlush([cell, save]);

  // Create an attack log for the attack
  if (save.type !== BaseType.TRIBE) {
    const defender = await postgres.em.findOne(User, {
      userid: save.saveuserid,
    });

    if (!defender) throw new Error("Defender user not found.");
    await createAttackLog(user, defender, save);
  }

  return await validateRange(user, save, mapversion, { baseid });
};
