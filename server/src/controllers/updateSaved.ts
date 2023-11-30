import { flags } from "../data/flags";
import { Save } from "../models/save.model";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

export const updateSaved: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let save = user.save;

  if (!save) {
    ctx.status = 404;
    ctx.body = { message: "Save not updated" };
    return;
  }

  // Update the save timestamp
  save.savetime = getCurrentDateTime();
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
