import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { Save } from "../../../models/save.model";
import { Status } from "../../../enums/StatusCodes";

interface TransferAssetsRequest {
    frombaseid: string
    tobaseid: string
    monsters: string
}

// TODO: Rewrite
export const transferAssets: KoaController = async (ctx) => {
    const request = <TransferAssetsRequest>ctx.request.body;
    const monsters = JSON.parse(request.monsters)
    let error = 1;
    if (monsters.length == 2) {
        const fromMonsters = monsters[0];
        const toMonsters = monsters[1]

        const fromBase = await ORMContext.em.findOne(Save, {
            baseid: request.frombaseid
        })

        const toBase = await ORMContext.em.findOne(Save, {
            baseid: request.tobaseid,
        })

        if (fromBase && toBase) {
            fromBase.monsters = fromMonsters;
            toBase.monsters = toMonsters;

            await ORMContext.em.persistAndFlush(fromBase)
            await ORMContext.em.persistAndFlush(toBase)
            error = 0;
        }
    }

    ctx.status = Status.OK;
    ctx.body = {
        error,
    }
}