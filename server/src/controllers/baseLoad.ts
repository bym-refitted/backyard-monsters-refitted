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
import { STATUS } from "../enums/StatusCodes";

// MR2 ToDo: The client sends this data to the server: {"baseid":"1234","type":"view","userid":""}
// In this example, the baseid '1234' is a hardcoded value in wildMonsterCell.ts for a tribe's base,
// The 'baseid' should be used to lookup & return a base in the database with the corresponding id
export const baseLoad: KoaController = async (ctx) => {
  // Try find an already existing save
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save = user.save;
  logging(
    `Loading base for user: ${ctx.authUser.username} | IP Address: ${ctx.ip}`
  );

  if (save) {
    if (process.env.ENV === ENV.LOCAL) {
      logging(`Base loaded:`, JSON.stringify(save, null, 2));
    }
  } else {
    // There was no existing save, create one with some defaults
    logging(`Base not found, creating a new save`);

    save = ORMContext.em.create(Save, getDefaultBaseData(user));

    // Add the save to the database
    await ORMContext.em.persistAndFlush(save);

    user.save = save;

    // Update user base save
    await ORMContext.em.persistAndFlush(user);
  }
  const filteredSave = FilterFrontendKeys(save);

  const isTutorialEnabled = devConfig.skipTutorial ? 205 : 0;

  ctx.status = STATUS.OK;
  ctx.body = {
    flags,
    error: 0,
    currenttime: getCurrentDateTime(),
    basename: "basename",
    pic_square: "https://apprecs.org/ios/images/app-icons/256/df/634186975.jpg",
    storeitems: { ...storeItems },
    ...filteredSave,
    id: filteredSave.basesaveid,
    tutorialstage: isTutorialEnabled,
  };
};
