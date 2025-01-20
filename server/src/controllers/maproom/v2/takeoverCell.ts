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
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

const TakeoverCellSchema = z.object({
  baseid: z.string(),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

/**
 * Controller to handle the takeover of a cell on the world map via shiny or resources.
 *
 * Retrieve the cell that is being taken over, by querying it with the baseid from the client.
 * To transfer ownership, update properties on the user, user's save, the cell and the associated cell save.
 * The previous owner's outposts are updated to reflect the takeover.
 * 
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
        base_id: BigInt(baseid),
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
    if (resources) userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    if (cellSave.damage < 90) 
      throw new Error("Cell is not damaged enough to be taken over.");

    // Find the previous owner
    const previousOwner = await ORMContext.em.findOne(
      User,
      { userid: cellSave.userid },
      { populate: ["save"] }
    );

    if (previousOwner?.save) {
      const { outposts } = previousOwner.save;

      // Filter out the outpost that matches the specified cell
      previousOwner.save.outposts = outposts.filter(
        ([x, y, id]) => !(x === cell.x && y === cell.y && id === baseid)
      );

      // Remove the `buildingresources` entry for this outpost
      const buildingresources = previousOwner.save.buildingresources;

      if (buildingresources && buildingresources[`b${baseid}`]) {
        delete buildingresources[`b${baseid}`];
      }

      await ORMContext.em.persistAndFlush(previousOwner);
    }

    // Update save
    cellSave.saveuserid = currentUser.userid;
    cellSave.userid = userSave.userid;
    cellSave.homebaseid = userSave.homebaseid;
    cellSave.homebase = [cell.x.toString(), cell.y.toString()];
    cellSave.name = userSave.name;
    cellSave.createtime = getCurrentDateTime();

    cellSave.protected = 1;
    cellSave.attackTimestamps = [];
    cellSave.resources = {};
    cellSave.tutorialstage = 205;

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
    await ORMContext.em.persistAndFlush([cellSave, currentUser]);

    ctx.status = Status.OK;
    ctx.body = { error: 0 };
  } catch (error) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    errorLog("Error taking over cell:", error);
  }
};
