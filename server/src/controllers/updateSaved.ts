import { flags } from "../data/flags";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

export const updateSaved: KoaController = async (ctx) => {
  const basesaveid = ctx.session.basesaveid;
  let save = await ORMContext.em.findOne(Save, { basesaveid });

  if (!save) {
    ctx.status = 404;
    ctx.body = { message: "Save not updated" };
    return;
  }

  // Update the save timestamp
  save.savetime = getCurrentDateTime();
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  await ORMContext.em.persistAndFlush(save);

  const filteredSave = FilterFrontendKeys(save);

  const baseUpdateSave = {
    error: 0,
    flags,
    ...filteredSave,
    h: "someHashValue",
  };

  ctx.status = 200;
  ctx.body = baseUpdateSave;
};
