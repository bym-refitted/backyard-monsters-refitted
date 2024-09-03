import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { Save } from "../../../models/save.model";
import { subtractResources, updateResources } from "../../../services/base/updateResources";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { Status } from "../../../enums/StatusCodes";

interface TakeoverCellRequest {
    baseid: string
    resources?: string
    shiny?: string
}

// TODO: Rewrite
export const takeoverCell: KoaController = async (ctx) => {
    const user: User = ctx.authUser;
    await ORMContext.em.populate(user, ["save"]);
    const authSave = user.save;
    const request = <TakeoverCellRequest>ctx.request.body;

    const save = await ORMContext.em.findOne(Save, {
        baseid: request.baseid,
    })

    let error = 1;
    if (save && save.type != 'main') {
        error = 0;

        if (save.saveuserid === 0) {
            save.buildingdata = {}
            save.buildinghealthdata = {};
            save.flinger = 0;
            save.catapult = 0;
        }

        if (request.resources) {
            authSave.resources = subtractResources(JSON.parse(request.resources), authSave.resources || {});
        } else if (request.shiny) {
            const credits = parseInt(request.shiny)
            if (authSave.credits - credits < 0) {
                error = 1;
            } else {
                authSave.credits = Math.max(0, authSave.credits - credits)
            }
        }

        if (error === 0) {
            const cell = await ORMContext.em.findOne(WorldMapCell, {
                base_id: parseInt(save.baseid)
            })
            if (cell) {
                /**
                 * Delete outpost record from the owner save
                 */
                if (save.saveuserid !== 0) {
                    const owner = await ORMContext.em.findOne(Save, {
                        baseid: save.homebaseid.toString(),
                    })
                    if (owner) {
                        owner.outposts = owner.outposts.filter(o => o[2] != parseInt(save.baseid))
                        delete owner.buildingresources[`b${save.baseid}`]
                        await ORMContext.em.persistAndFlush(owner);
                    }
                }

                const outposts = [cell.x, cell.y, parseInt(save.baseid)];
                save.saveuserid = user.userid;
                save.type = "outpost"
                save.resources = {}
                save.wmid = 0;
                save.name = authSave.name
                save.basename = authSave.basename;
                save.protected = 1;
                cell.base_type = 3;
                cell.uid = user.userid;
                if (authSave.outposts === null) {
                    authSave.outposts = [];
                }
                authSave.outposts.push(outposts);
                save.outposts = authSave.outposts;
                save.homebase = authSave.homebase;
                save.homebaseid = authSave.homebaseid
                save.points = authSave.points;
                save.basevalue = authSave.basevalue;
                save.level = calculateBaseLevel(authSave.points, authSave.basevalue);
                save.researchdata = {};
                save.stats = {};
                save.champion = "null";
                save.credits = 0;
                save.storedata = {};

                await Promise.all([
                    ORMContext.em.persistAndFlush(cell),
                    ORMContext.em.persistAndFlush(save),
                    ORMContext.em.persistAndFlush(authSave),
                ]);
            }
        }
    }

    ctx.status = Status.OK;
    ctx.body = {
        error: error,
    };
};
