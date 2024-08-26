import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { Save } from "../../../models/save.model";
import { joinOrCreateWorld } from "../../../services/maproom/v2/joinOrCreateWorld";
import { subtractResources } from "../../../services/base/updateResources";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Status } from "../../../enums/StatusCodes";

interface MigrateBaseRequest {
    shiny?: string,
    baseid: string,
    type: string,
    resources?: string
}
export const migrateBase: KoaController = async (ctx) => {
    console.log("migrating base", ctx.request.body)
    const request = <MigrateBaseRequest>ctx.request.body;
    const user: User = ctx.authUser;
    await ORMContext.em.populate(user, ["save"]);
    const save: Save = user.save;
    let error = 0;

    if (request.resources) {
        save.resources = subtractResources(JSON.parse(request.resources), save.resources || {});
    } else if (request.shiny) {
        const credits = parseInt(request.shiny)
        if (save.credits - credits < 0) {
            error = 1;
        } else {
            save.credits = Math.max(0, save.credits - credits)
        }
    }

    if (request.type === "outpost") {
        const homecell = await ORMContext.em.findOne(WorldMapCell, {
            base_id: save.homebaseid,
        })

        const cell = await ORMContext.em.findOne(WorldMapCell, {
            base_id: parseInt(request.baseid, 10)
        })
        const outpost = await ORMContext.em.findOne(Save, {
            baseid: request.baseid
        })

        if (homecell && cell && outpost) {
            save.homebase = [cell.x.toString(), cell.y.toString()]
            save.outposts = save.outposts.filter(o => o[2] != parseInt(outpost.baseid))
            delete save.buildingresources[`b${outpost.baseid}`]
            homecell.x = cell.x
            homecell.y = cell.y
            await Promise.all([
                ORMContext.em.removeAndFlush(cell),
                ORMContext.em.removeAndFlush(outpost),
                ORMContext.em.persistAndFlush(homecell),
                ORMContext.em.persistAndFlush(save)
            ])
        }
    } else {
        await joinOrCreateWorld(user, save, true)
    }

    //
    const outposts = await ORMContext.em.find(Save, {
        homebaseid: save.homebaseid,
        type: "outpost",
    })

    outposts.map(base => {
        base.homebase = save.homebase
        return base;
    })
    // Update outposts homebase
    await ORMContext.em.persistAndFlush(outposts);

    ctx.status = Status.OK;
    ctx.body = {
        error: error,
        resources: save.resources
    }
}