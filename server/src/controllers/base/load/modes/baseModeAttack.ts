import { BaseMode } from "../../../../enums/Base";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { World } from "../../../../models/world.model";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { ORMContext } from "../../../../server";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { wildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../config/WorldGenSettings";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";
import { validateRange } from "../../../../services/maproom/v2/validateRange";

export const baseModeAttack = async (user: User, baseid: string) => {
  const userSave: Save = user.save;
  let save = await ORMContext.em.findOne(Save, { baseid: BigInt(baseid) });

  if (!save) save = wildMonsterSave(baseid);

  // Record the timestamp of the attack
  const currentTimestamp = getCurrentDateTime();
  if (save.attackTimestamps.length > 10)
    save.attackTimestamps = save.attackTimestamps.slice(-9);
  
  save.attackTimestamps.push(currentTimestamp);

  // Remove damage protection
  await damageProtection(userSave, BaseMode.ATTACK);

  let cell = await ORMContext.em.findOne(WorldMapCell, {
    base_id: BigInt(baseid),
  });

  if (!cell) {
    // Find the existing world record
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
    cell.base_id = BigInt(baseid);
  }

  save.cell = cell;
  save.worldid = userSave.worldid;
  save.attackid = Math.floor(Math.random() * 99999) + 1;
  await ORMContext.em.persistAndFlush([cell, save]);

  return await validateRange(user, save, { baseid });
};
