import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import {
  deleteOutposts,
  deleteWorldMapBase,
  joinOrCreateWorld,
} from "../../../services/maproom/v2/joinOrCreateWorld";
import { Save } from "../../../models/save.model";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { User } from "../../../models/user.model";
import { MAPROOM_VERSION } from "../../../enums/MapRoom";

export const setMapVersion: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save: Save = user.save;
  const { version } = ctx.request.body as { version: string };

  if (version === MAPROOM_VERSION.V2) {
    save.usemap = 1;
    await joinOrCreateWorld(user, save);
  } else {
    save.usemap = 0;
    await removePlayerFromWorld(user, save);
  }

  await ORMContext.em.persistAndFlush(save);
  const filteredSave = FilterFrontendKeys(save);

  ctx.status = 200;
  ctx.body = {
    error: 0,
    baseurl: `${process.env.BASE_URL}:${process.env.PORT}/base/`,
    ...filteredSave,
    id: filteredSave.basesaveid,
  };
};

const removePlayerFromWorld = async (user: User, save: Save) => {
  await deleteWorldMapBase(user);
  await deleteOutposts(user);

  save.worldid = "";
  save.cellid = 0;
  save.homebase = null;
  save.outposts = [];
};
