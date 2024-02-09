import { flags } from "../data/flags";
import { saveFailureErr } from "../errors/errorCodes.";
import { Save } from "../models/save.model";
import { User } from "../models/user.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";

export const updateSaved: KoaController = async (ctx) => {
  const user = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);
  let save = user.save

  if (!save) throw saveFailureErr;
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

export const socketUpdateSaved = async (userID: string, data: object) => {
  const fork = ORMContext.em.fork();

  const user = await fork.findOne(User, { userid: parseInt(userID) });
  await fork.populate(user, ["save"]);
  let save = user.save;

  save.savetime = getCurrentDateTime();
  
  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  await fork.persistAndFlush(save);

  const filteredSave = FilterFrontendKeys(save);

  const baseUpdateSave = {
    error: 0,
    flags,
    ...filteredSave,
  };

  return baseUpdateSave
}
