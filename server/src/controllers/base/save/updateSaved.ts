import { flags } from "../../../data/flags";
import { BaseMode } from "../../../enums/Base";
import { Status } from "../../../enums/StatusCodes";
import { saveFailureErr } from "../../../errors/errorCodes.";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { KoaController } from "../../../utils/KoaController";
import { buildBase } from "../load/modes/buildBase";
import { viewBase } from "../load/modes/viewBase";

export const updateSaved: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const baseid = ctx.request.body['baseid'];
  const type = ctx.request.body['type'];

  await ORMContext.em.populate(user, ["save"]);
  const authSave = user.save;
  let save: Save;

  // TODO: Rewrite, why do this?
  if (type === BaseMode.BUILD) {
    save = await buildBase(ctx, baseid);
  } else {
    save = await viewBase(ctx, baseid);
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
