import { gameConfig } from "../config/GameSettings";
import { Save } from "../models/save.model";
import { ORMContext } from "../server";
import { KoaController } from "../utils/KoaController";
import { logging } from "../utils/logger";
import { storeKeys } from "../keys/generalStore";
import { User } from "../models/user.model";
import { getDefaultBaseData } from "../data/getDefaultBaseData";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { flags } from "../data/flags";

export const baseLoad: KoaController = async ctx => {
  // Try find an already existing save
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save = user.save;
  logging(`Loading base for user: ${ctx.authUser.username}`);
  if (save) {
    logging(`Base loaded:`, JSON.stringify(save, null, 2));
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

  const storeObject = {
    t: "title_val",
    d: "desc_val",
    c: [0],
    i: "",
    q: 0,
    du: 0,
  };

  const quantities = {};
  storeKeys.forEach((key) => {
    quantities[key] = 100;
  });

  const storeItems = {};
  storeKeys.forEach((key) => {
    if (quantities[key]) {
      storeItems[key] = { ...storeObject, quantity: quantities[key] };
    } else {
      storeItems[key] = { ...storeObject };
    }
  });

  const isTutorialEnabled = gameConfig.skipTutorial ? 205 : 0;

  ctx.status = 200;
  ctx.body = {
    flags,
    error: 0,
    basename: "testBase",
    pic_square: "https://apprecs.org/ios/images/app-icons/256/df/634186975.jpg",
    storeitems: { ...storeItems },
    ...filteredSave,
    id: filteredSave.basesaveid,
    tutorialstage: isTutorialEnabled,
    iresources: filteredSave.resources,
    // Important: 'h' must always be at the end of the payload, as the client checks for this
    h: "someHashValue",
    hn: 0,
  };
};
