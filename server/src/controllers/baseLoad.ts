import { devConfig } from "../config/DevSettings";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeItems } from "../data/storeItems";
import { User } from "../models/user.model";
import { getDefaultBaseData } from "../data/getDefaultBaseData";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { flags } from "../data/flags";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { WorldMapCell } from "../models/worldmapcell.model";
import { generateID } from "../utils/generateID";
import { loadBuildBase, loadViewBase } from "../services/base/loadBase";
import { saveFailureErr } from "../errors/errorCodes.";
import { removeBaseProtection } from "../services/maproom/v2/joinOrCreateWorld";
import { BaseMode } from "../enums/Base";
import { Env } from "../enums/Env";
import { generateNoise, getTerrainHeight } from "../config/WorldGenSettings";
import { World } from "../models/world.model";
import { Status } from "../enums/StatusCodes";

interface BaseLoadRequest {
  type: string;
  userid: string;
  baseid: string;
  cellid: string;
}

export const baseLoad: KoaController = async (ctx) => {
  const requestBody: BaseLoadRequest = <BaseLoadRequest>ctx.request.body;

  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);
  const userSave = user.save;
  let save: Save = null;

  if (requestBody.type === BaseMode.BUILD) {
    save = await loadBuildBase(ctx, requestBody.baseid);
    if (save && save.saveuserid !== user.userid) {
      throw saveFailureErr;
    }
  } else {
    console.log("Loading view base", requestBody.baseid);
    save = await loadViewBase(ctx, requestBody.baseid);
  }

  logging(
    `Loading base for user: ${ctx.authUser.username} | IP Address: ${ctx.ip} | Base ID: ${requestBody.baseid}`
  );

  if (save) {
    if (process.env.ENV === Env.LOCAL) {
      logging(`Base loaded:`, JSON.stringify(save, null, 2));
    }
  } else if (requestBody.baseid && requestBody.baseid === "0") {
    // There was no existing save, create one with some defaults
    logging(`Base not found, creating a new save`);

    save = ORMContext.em.create(Save, getDefaultBaseData(user));

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);

    user.save = save;

    // Update user base save
    await ORMContext.em.persistAndFlush(user);
  }

  if (!save) throw saveFailureErr;

  if (requestBody.type === BaseMode.ATTACK) {
    await removeBaseProtection(user, save.homebase);
    save.attackid = generateID(5);
    if (save.homebaseid === 0) {
      let cell = await ORMContext.em.findOne(WorldMapCell, {
        base_id: save.basesaveid,
      });
      if (!cell) {
        // Create a cell record when attacking tribe bases
        const world = await ORMContext.em.findOne(World, {
          uuid: userSave.worldid,
        });

        if (!world) throw new Error("No world found.");

        const baseIdSplit = [...`${requestBody.baseid}`];
        const cellX = parseInt(baseIdSplit.slice(1, 4).join(""));
        const cellY = parseInt(baseIdSplit.slice(4).join(""));
        const cell = new WorldMapCell(
          world,
          cellX,
          cellY,
          getTerrainHeight(generateNoise(userSave.worldid), cellX, cellY),
          {
            base_id: parseInt(baseIdSplit.join()),
            uid: save.saveuserid,
            base_type: 1,
          }
        );

        await ORMContext.em.persistAndFlush(cell);
        save.homebaseid = parseInt(baseIdSplit.join());
        save.cellid = cell.cell_id;
        save.worldid = world.uuid;
      }
    }
    await ORMContext.em.persistAndFlush(save);
  }
  const filteredSave = FilterFrontendKeys(save);

  const isTutorialEnabled = devConfig.skipTutorial ? 205 : 0;

  ctx.status = Status.OK;
  ctx.body = {
    flags,
    error: 0,
    currenttime: getCurrentDateTime(),
    pic_square: `https://api.dicebear.com/9.x/miniavs/png?seed=${save.name}`,
    storeitems: { ...storeItems },
    ...filteredSave,
    id: filteredSave.basesaveid,
    tutorialstage: isTutorialEnabled,
  };
};
