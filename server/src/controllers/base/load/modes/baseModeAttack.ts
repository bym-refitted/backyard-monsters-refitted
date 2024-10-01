import { Context } from "koa";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../config/WorldGenSettings";
import { BaseMode } from "../../../../enums/Base";
import { MapRoomCell } from "../../../../enums/MapRoom";
import { World } from "../../../../models/world.model";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { ORMContext } from "../../../../server";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { generateID } from "../../../../utils/generateID";
import { baseModeView } from "./baseModeView";
import { Save } from "../../../../models/save.model";

// TODO: Rewrite
export const baseModeAttack = async (
  ctx: Context,
  baseid: string,
  userSave: Save
) => {
  await damageProtection(userSave, BaseMode.ATTACK);
  let baseSave = await baseModeView(ctx, baseid);
  baseSave.attackid = generateID(5);
  if (baseSave.homebaseid === 0) {
    let cell = await ORMContext.em.findOne(WorldMapCell, {
      base_id: baseSave.basesaveid,
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

      // Why are we generating terrain for an attack??
      const cell = new WorldMapCell(
        world,
        cellX,
        cellY,
        getTerrainHeight(noise, userSave.worldid, cellX, cellY),
        {
          base_id: parseInt(baseIdSplit.join()),
          uid: baseSave.saveuserid,
          base_type: MapRoomCell.WM,
        }
      );

      cell.base_id = parseInt(baseSave.baseid); // Revisit
      await ORMContext.em.persistAndFlush(cell);

      baseSave.homebaseid = parseInt(baseIdSplit.join());
      baseSave.cell = cell;
      baseSave.worldid = world.uuid;
    }
  }
  await ORMContext.em.persistAndFlush(baseSave);
  return baseSave;
};
