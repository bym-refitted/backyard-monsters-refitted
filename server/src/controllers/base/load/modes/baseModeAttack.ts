import { BaseMode } from "../../../../enums/Base";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { World } from "../../../../models/world.model";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { ORMContext } from "../../../../server";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { generateID } from "../../../../utils/generateID";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { wildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../config/WorldGenSettings";

export const baseModeAttack = async (user: User, baseid: string) => {
  const userSave: Save = user.save;
  let save = await ORMContext.em.findOne(Save, { baseid });

  if (!save) save = wildMonsterSave(baseid);

  // Remove damage protection
  await damageProtection(userSave, BaseMode.ATTACK);

  if (save.homebaseid === 0) {
  const cell = await ORMContext.em.findOne(WorldMapCell, {
    base_id: save.basesaveid,
  });

  if (!cell) {
    // Create a cell record when attacking tribe bases
    const world = await ORMContext.em.findOne(World, {
      uuid: userSave.worldid,
    });

    if (!world) throw new Error("No world found.");

    const baseIdSplit = [...`${baseid}`];
    const cellX = parseInt(baseIdSplit.slice(1, 4).join(""));
    const cellY = parseInt(baseIdSplit.slice(4).join(""));
    const noise = generateNoise(world.uuid);

    const cell = new WorldMapCell(
      world,
      cellX,
      cellY,
      getTerrainHeight(noise, cellX, cellY),
      {
        base_id: parseInt(baseIdSplit.join()),
        uid: save.saveuserid,
        base_type: MapRoomCell.WM,
      }
    );

    cell.base_id = parseInt(save.baseid); // Revisit
    await ORMContext.em.persistAndFlush(cell);

    save.attackid = generateID(5);
    save.homebaseid = parseInt(baseIdSplit.join());
    save.cell = cell;
    save.worldid = world.uuid;
  }
  }
  await ORMContext.em.persistAndFlush(save);
  return save;
};
