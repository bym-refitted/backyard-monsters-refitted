import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { getBounds, getFreeCell, getFreeWorld } from "./world";
import { logging } from "../../../utils/logger";

export const joinWorldMap = async (user: User, save: Save, migrate: Boolean = false): Promise<WorldMapCell> => {
    const fork = ORMContext.em.fork();
    const homeBase = await fork.findOne(WorldMapCell, {
        uid: user.userid,
        base_type: 2,
    })

    if (homeBase) {
        if (migrate) {
            const cell = await getFreeCell(homeBase.world_id, true)
            homeBase.x = cell.x;
            homeBase.y = cell.y;
            await fork.persistAndFlush(homeBase)
            save.homebase = [cell.x.toString(), cell.y.toString()]
            await fork.persistAndFlush(save)
        }
        return homeBase;
    }

    const world_id = await getFreeWorld();
    const cell = await getFreeCell(world_id)
    logging(`USER ${user.userid} | Joining world: ${world_id} | ${cell.x}-${cell.y}`, cell)

    cell.uid = user.userid;
    cell.base_type = 2
    cell.base_id = parseInt(save.baseid);

    await fork.persistAndFlush(cell)
    save.cellid = cell.cell_id;
    save.worldid = world_id;
    save.homebase = [cell.x.toString(), cell.y.toString()]
    await fork.persistAndFlush(save)

    return cell;
}

export const deleteWorldMapBase = async (user: User) => {
    const fork = ORMContext.em.fork();
    const homeBase = await fork.findOne(WorldMapCell, {
        uid: user.userid
    })

    if (homeBase) {
        ORMContext.em.remove(homeBase);
    }
}

export const deleteOutposts = async (user: User) => {
    const fork = ORMContext.em.fork();

    const cells = await fork.find(WorldMapCell, {
        uid: user.userid,
    })

    const outposts = await fork.find(Save, {
        saveuserid: user.userid,
        type: "outpost",
    })

    await fork.removeAndFlush(cells)
    await fork.removeAndFlush(outposts)
}

export const removeBaseProtection = async (user: User, homebase: Array<string>) => {
    const fork = ORMContext.em.fork();
    await fork.populate(user, ["save"])
    const authSave = user.save;
    const [x, y] = homebase;

    const width = 3;
    const currentX = parseInt(x);
    const currentY = parseInt(y);
    const { minX, minY, maxX, maxY, } = getBounds(currentX, currentY, width);

    const wCells = await fork.find(WorldMapCell, {
        x: {
            $gte: minX,
            $lte: maxX,
        },
        y: {
            $gte: minY,
            $lte: maxY,
        },
        world_id: "1", // ToDo: implement a world table?
        uid: user.userid
    })

    const baseids = wCells.map((cell) => cell.base_id.toString(10));

    const bases = await fork.find(Save, {
        baseid: {
            $in: baseids,
        }
    })

    bases.map((base) => {
        base.protected = 0;
        return base;
    })

    authSave.protected = 0;
    await fork.persistAndFlush(bases)
    await fork.persistAndFlush(authSave)
}