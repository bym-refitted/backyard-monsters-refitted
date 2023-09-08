import Router from "@koa/router";
import { debugDataLog } from "../middleware/debugDataLog";
import { ORMContext } from "../server";
import { Save } from "../models/save.model";
import { logging } from "../utils/logger";
import { KoaController } from "../utils/KoaController";
import { Context, Next } from "koa";

const router = new Router();

const updateSaved: KoaController = async ctx => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    baseid: 1234,
    version: 128,
    lastupdate: 0,
    type: "build",
    flags: {
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      midgameIncentive: 0,
      plinko: 0,
      fanfriendbookmarkquests: 0,
    },
    h: "someHashValue",
  };
};

router.post(
  "/base/save",
  debugDataLog("Base save data"),
  async (ctx: Context) => {
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
);

router.get(
  "/base/updatesaved",
  debugDataLog(),
  async (ctx: Context) => updateSaved(ctx)
);
router.post(
  "/base/updatesaved",
  debugDataLog("Base updated save"),
  async (ctx: Context) => updateSaved(ctx)
);

export default router;
