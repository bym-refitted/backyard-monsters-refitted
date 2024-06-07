import { devConfig } from "../config/DevSettings";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeItems } from "../data/storeItems";
import { User } from "../models/user.model";
import { getDefaultBaseData } from "../data/getDefaultBaseData";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { flags } from "../data/flags";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { ENV } from "../enums/Env";
import { authFailureErr, saveFailureErr } from "../errors/errorCodes.";

/**
 * Controller for handling the loading of a user's base.
 * Attempts to find an existing save for the user.
 * If a save is found, return it.
 * If no save is found, create a new save with default data, add it to the DB, update the user's save, and return.
 * Filters the save for frontend keys, and sets the response status and body.
 */
export const baseLoad: KoaController = async (ctx) => {
  if (!ctx.authUser || !(ctx.authUser instanceof User)) throw authFailureErr();

  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save = user.save;
  logging(
    `Loading base for user: ${ctx.authUser.username} | IP Address: ${ctx.ip}`
  );

  if (save && process.env.ENV === ENV.LOCAL) {
    logging(`Base loaded:`, JSON.stringify(save, null, 2));
  } else {
    logging(`Base not found, creating a new save`);

    try {
      save = ORMContext.em.create(Save, getDefaultBaseData(user));
      await ORMContext.em.persistAndFlush(save);

      user.save = save;
      await ORMContext.em.persistAndFlush(user);
    } catch (error) {
      throw saveFailureErr();
    }
  }

  const filteredSave = FilterFrontendKeys(save);
  const isTutorialEnabled = devConfig.skipTutorial ? 205 : 0;

  ctx.status = 200;
  ctx.body = {
    flags,
    error: 0,
    currenttime: getCurrentDateTime(),
    basename: "basename",
    pic_square: "",
    storeitems: { ...storeItems },
    ...filteredSave,
    id: filteredSave.basesaveid,
    tutorialstage: isTutorialEnabled,
  };
};