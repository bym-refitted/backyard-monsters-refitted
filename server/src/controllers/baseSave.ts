import { Save } from "../models/save.model";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";

export const baseSave: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  logging(`Saving the base! user: ${user.username}`);

  await ORMContext.em.populate(user, ["save"]);
  let save = user.save;

  ctx.session.basesaveid = save.basesaveid;

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

  const baseSaveData = {
    error: 0,
    basesaveid: save.basesaveid,
    installsgenerated: 42069,
  };

  ctx.status = 200;
  ctx.body = {
    ...baseSaveData,
    ...filteredSave,
    // over: (save.over += 1),
    h: "someHashValue",
  };
};
