import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";

export const baseSave: KoaController = async ctx => {
    logging(`Saving the base!`);

    const requestBody = ctx.request.body as { basesaveid: number };

    let save = await ORMContext.em.findOne(Save, {
      basesaveid: requestBody.basesaveid,
    });

    // update the save with the values from the request
    for (const key of Save.jsonKeys) {
      ctx.request.body[key] = JSON.parse(ctx.request.body[key]);
    }
    // Equivalent to Object.assign() - merges second object onto entity
    ORMContext.em.assign(save, ctx.request.body);
    // Execute the update in the db
    await ORMContext.em.persistAndFlush(save);

    // hardcoded for now
    const baseSaveData = {
      error: 0,
      over: 1,
      basesaveid: requestBody.basesaveid,
      credits: 2000,
      protected: 1,
      fan: 0,
      bookmarked: 0,
      installsgenerated: 42069,
      resources: {},
      h: "someHashValue",
    };
    ctx.status = 200;
    ctx.body = { ...baseSaveData };
}