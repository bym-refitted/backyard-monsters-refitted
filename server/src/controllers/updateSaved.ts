import { flags } from "../data/flags";
import { saveFailureErr } from "../errors/errorCodes.";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { KoaController } from "../utils/KoaController";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { User } from "../models/user.model";
import { loadBuildBase, loadViewBase } from "../services/base/loadBase";
import { Status } from "../enums/StatusCodes";

export const updateSaved: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const baseid = ctx.request.body['baseid'];
  const type = ctx.request.body['type'];

  await ORMContext.em.populate(user, ["save"]);
  const authSave = user.save;
  let save: Save;

  if (type === "build") {
    save = await loadBuildBase(ctx, baseid);
  } else {
    save = await loadViewBase(ctx, baseid);
  }

  if (!save) throw saveFailureErr();
  save.savetime = getCurrentDateTime();

  // Set the id field (_lastSaveID) to be the same as savetime, client expects this.
  save.id = save.savetime;

  if (save.baseid !== "0" && type === "build") {
    await ORMContext.em.persistAndFlush(save);
  }

  if (save.baseid !== authSave.baseid) {
    authSave.savetime = getCurrentDateTime();
    ORMContext.em.persist(authSave);
  }

  const filteredSave = FilterFrontendKeys(save)

  const baseUpdateSave = {
    error: 0,
    flags,
    ...filteredSave,
  };

  ctx.status = Status.OK;
  ctx.body = baseUpdateSave;
};
