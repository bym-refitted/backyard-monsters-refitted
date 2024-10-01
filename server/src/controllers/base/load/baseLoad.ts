import { devConfig } from "../../../config/DevSettings";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { KoaController } from "../../../utils/KoaController";
import { storeItems } from "../../../data/storeItems";
import { User } from "../../../models/user.model";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { flags } from "../../../data/flags";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { generateID } from "../../../utils/generateID";
import { loadFailureErr } from "../../../errors/errors";
import { BaseMode } from "../../../enums/Base";
import {
  generateNoise,
  getTerrainHeight,
  WORLD_SIZE,
} from "../../../config/WorldGenSettings";
import { World } from "../../../models/world.model";
import { Status } from "../../../enums/StatusCodes";
import { damageProtection } from "../../../services/maproom/v2/damageProtection";
import z from "zod";
import { baseModeView } from "./modes/baseModeView";
import { baseModeBuild } from "./modes/baseModeBuild";
import { MapRoomCell } from "../../../enums/MapRoom";
import { errorLog } from "../../../utils/logger";

const BaseLoadSchema = z.object({
  type: z.string(),
  userid: z.string(),
  baseid: z.string(),
});

export const baseLoad: KoaController = async (ctx) => {
  try {
    const { baseid, type } = BaseLoadSchema.parse(ctx.request.body);
    const user: User = ctx.authUser;
    await ORMContext.em.populate(user, ["save"]);

    const userSave = user.save;
    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(ctx, baseid);
        break;

      case BaseMode.VIEW:
        baseSave = await baseModeView(ctx, baseid);
        break;

      // TODO: Rewrite
      case BaseMode.ATTACK:
        await damageProtection(userSave, BaseMode.ATTACK);
        baseSave = await baseModeView(ctx, baseid);
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
        break;
      default:
        throw new Error(`Base type not handled, type: ${type}.`);
    }

    const filteredSave = FilterFrontendKeys(baseSave);
    const isTutorialEnabled = devConfig.skipTutorial
      ? 205
      : filteredSave.tutorialstage;

    ctx.status = Status.OK;
    ctx.body = {
      ...filteredSave,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      currenttime: getCurrentDateTime(),
      pic_square: `https://api.dicebear.com/9.x/miniavs/png?seed=${baseSave.name}`,
    };
  } catch (error) {
    errorLog(`Error loading base: ${error.message}`);
    throw loadFailureErr();
  }
};
