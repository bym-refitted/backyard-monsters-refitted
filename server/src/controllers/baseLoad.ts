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
import { removeBaseProtection } from "../services/maproom/v2";


interface BaseLoadRequest {
  type: string
  userid: string
  baseid: string
  cellid: string
}
// MR2 ToDo: The client sends this data to the server: {"baseid":"1234","type":"view","userid":""}
// In this example, the baseid '1234' is a hardcoded value in wildMonsterCell.ts for a tribe's base,
// The 'baseid' should be used to lookup & return a base in the database with the corresponding id
export const baseLoad: KoaController = async (ctx) => {
  const requestBody: BaseLoadRequest = <BaseLoadRequest>ctx.request.body
// console.log("LOADING BASE", ctx.request.body)

  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);
  const authSave = user.save;
  let save: Save = null;

  if (requestBody.type === "build") {
    save = await loadBuildBase(ctx, requestBody.baseid);
    if(save && save.saveuserid !== user.userid) {
      throw saveFailureErr;
    }
  } else {
    save = await loadViewBase(ctx, requestBody.baseid)
  }

  logging(
    `Loading base for user: ${ctx.authUser.username} | IP Address: ${ctx.ip} | Base ID: ${requestBody.baseid}`
  );
  if (save) {
    if (process.env.ENV === "local") {
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

  if (requestBody.type === "attack") {
    await removeBaseProtection(user, save.homebase)
    save.attackid = generateID(5)
    if (save.homebaseid === 0) {
      let cell = await ORMContext.em.findOne(WorldMapCell, {
        base_id: save.basesaveid,
      })
      if (!cell) {
        // Create a cell record when attacking tribe bases
        cell = ORMContext.em.create(WorldMapCell, {
          world_id: authSave.worldid,
          x: parseInt(save.homebase[0]),
          y: parseInt(save.homebase[1]),
          base_id: save.basesaveid,
          uid: save.saveuserid,
          base_type: 1,
        })
      }
      await ORMContext.em.persistAndFlush(cell);
      save.homebaseid = save.basesaveid;
      save.cellid = cell.cell_id;
      save.worldid = cell.world_id;
    }
    await ORMContext.em.persistAndFlush(save);
  }

  const filteredSave = FilterFrontendKeys(save);

  const isTutorialEnabled = devConfig.skipTutorial ? 205 : 0;

  ctx.status = 200;
  ctx.body = {
    flags,
    error: 0,
    currenttime: getCurrentDateTime(),
    pic_square: `https://api.dicebear.com/7.x/adventurer/png?backgroundType=solid&backgroundColor=b6e3f4,c0aede,d1d4f9&seed=${save.name}`,
    storeitems: { ...storeItems },
    ...filteredSave,
    id: filteredSave.basesaveid,
    tutorialstage: isTutorialEnabled,
  };
  
};
