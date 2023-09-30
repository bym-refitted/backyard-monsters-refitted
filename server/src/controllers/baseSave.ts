import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { errorLog, logging } from "../utils/logger";

export const baseSave: KoaController = async (ctx) => {
  const user = ctx.authUser;
  logging(`Saving the base! user: ${user.username}`);

  const requestBody = ctx.request.body as { basesaveid: number };

  let save = await ORMContext.em.findOne(Save, {
    basesaveid: requestBody.basesaveid,
  });
 // save.over += 1;

  // update the save with the values from the request
  for (const key of Save.jsonKeys) {
    try {
      ctx.request.body[key] = JSON.parse(ctx.request.body[key]);
    } catch (error) {
      // errorLog(`Error parsing JSON for key '${key}': ${error.message}`);
    }
  }
  // Equivalent to Object.assign() - merges second object onto entity
  ORMContext.em.assign(save, ctx.request.body);
  // Execute the update in the db
  await ORMContext.em.persistAndFlush(save);

  const filteredSave = FilterFrontendKeys(save);
  // hardcoded for now
  const baseSaveData = {
    error: 0,
    basesaveid: requestBody.basesaveid,
    credits: 2000,
    protected: 1, //protectedVal
    fan: 0,
    bookmarked: 0,
    installsgenerated: 42069,
    resources: {},
    h: "someHashValue",
  };
  ctx.status = 200;
  ctx.body = {
    ...baseSaveData,
    ...filteredSave,
    // over:0,
    protected: filteredSave.protectedVal,
  };
};
