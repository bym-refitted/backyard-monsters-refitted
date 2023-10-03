import { flags } from "../data/flags";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";

export const updateSaved: KoaController = async (ctx) => {
  const basesaveidCookie = ctx.cookies.get("basesaveid");
  const basesaveid = parseInt(basesaveidCookie, 10);
  let save = await ORMContext.em.findOne(Save, { basesaveid });

  if (!save) {
    ctx.status = 404;
    ctx.body = { message: "Save not updated" };
    return;
  }

  const filteredSave = FilterFrontendKeys(save);

  const baseUpdateSave = {
    error: 0,
    flags,
    ...filteredSave,
    protectedVal: filteredSave.protectedVal,
    h: "someHashValue",
  };

  ctx.status = 200;
  ctx.body = baseUpdateSave;
};
