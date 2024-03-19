import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { deleteOutposts, deleteWorldMapBase, joinWorldMap } from "../../../services/maproom/v2";
import { Save } from "../../../models/save.model";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { User } from "../../../models/user.model";

export const setMapVersion: KoaController = async (ctx) => {
    const user: User = ctx.authUser;
    const version = ctx.request.body["version"]
    await ORMContext.em.populate(user, ["save"]);
    let save: Save = user.save;

    if (version == "1") {
        await deleteWorldMapBase(user);
        await deleteOutposts(user);

        save.worldid = "";
        save.cellid = 0;
        save.homebase = null
        save.outposts = []
        save.usemap = 0;
    } else if (version === "2") {
        save.usemap = 1;
        await joinWorldMap(user, save)
    }

    await ORMContext.em.persistAndFlush(save);
    const filteredSave = FilterFrontendKeys(save);

    ctx.status = 200;
    ctx.body = {
        error: 0,
        baseurl: `${process.env.BASE_URL}:${process.env.PORT}/base/`,
        ...filteredSave,
        id: filteredSave.basesaveid,
    }
};