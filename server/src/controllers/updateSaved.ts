import { flags } from "../data/flags";
import { saveFailureErr } from "../errors/errorCodes.";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import {User} from "../models/user.model";

export const updateSaved: KoaController = async (ctx) => {
  const user: User = ctx.authUser;

  await ORMContext.em.populate(user, ["save"]);
  let save = user.save;

  if (!save) throw saveFailureErr();
  save.savetime = getCurrentDateTime();
  
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  await ORMContext.em.persistAndFlush(save);

  const filteredSave = FilterFrontendKeys(save);

  const baseUpdateSave = {
    error: 0,
    flags,
    ...filteredSave,
  };

  ctx.status = 200;
  ctx.body = baseUpdateSave;
};
