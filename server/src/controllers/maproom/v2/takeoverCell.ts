import z from "zod";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Status } from "../../../enums/StatusCodes";
import { BaseType } from "../../../enums/Base";
import { MapRoomCell } from "../../../enums/MapRoom";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources";
import { errorLog } from "../../../utils/logger";

const TakeoverCellSchema = z.object({
  baseid: z.string().transform((baseid) => parseInt(baseid)),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

/**
 * Controller to handle the takeover of a cell on the world map via shiny or resources.
 *
 * Retrieve the cell that is being taken over, by querying it with the baseid from the client.
 * To transfer ownership, update properties on the user, user's save, the cell and the associated cell save.
 * @param {Context} ctx - The Koa context object.
 * @throws Will throw an error if the base or base type is invalid.
 */
export const takeoverCell: KoaController = async (ctx) => {
  try {
    const { baseid, resources, shiny } = TakeoverCellSchema.parse(
      ctx.request.body
    );

    const currentUser: User = ctx.authUser;
    await ORMContext.em.populate(currentUser, ["save"]);

    const userSave = currentUser.save;

    const cell = await ORMContext.em.findOne(
      WorldMapCell,
      {
        base_id: baseid,
      },
      { populate: ["save"] }
    );

    if (!cell || !cell.save || cell.save.type === BaseType.MAIN) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error(`Invalid base or base type. Base ID: ${baseid}`);
    }

    const cellSave = cell.save;

    if (shiny) userSave.credits = userSave.credits - shiny;
    if (resources) 
      userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    // Update save
    cellSave.saveuserid = currentUser.userid;
    cellSave.userid = userSave.userid;
    cellSave.homebaseid = userSave.homebaseid;
    cellSave.homebase = [cell.x.toString(), cell.y.toString()];

    if (cellSave.type === BaseType.TRIBE) {
      cellSave.type = BaseType.OUTPOST;
      cellSave.buildingdata = {};
      cellSave.wmid = 0;
    }

    // Update cell
    cell.uid = currentUser.userid;
    cell.base_type = MapRoomCell.OUTPOST;

    // Update user
    userSave.outposts.push([cell.x, cell.y, baseid]);
    ORMContext.em.persistAndFlush([cellSave, currentUser]);

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (error) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    errorLog("Error taking over cell:", error);
  }
};
