import z from "zod";
import _ from "lodash";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { Save } from "../../../models/save.model";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { Status } from "../../../enums/StatusCodes";
import { BaseType } from "../../../enums/Base";
import { logging } from "../../../utils/logger";
import { MapRoomCell } from "../../../enums/MapRoom";

const TakeoverCellSchema = z.object({
  baseid: z.string().transform((baseid) => parseInt(baseid)),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

export const takeoverCell: KoaController = async (ctx) => {
  const { baseid, resources, shiny } = TakeoverCellSchema.parse(ctx.request.body);
  
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let { credits, outposts, resources: savedResources } = user.save;

  const cell = await ORMContext.em.findOne(
    WorldMapCell,
    {
      base_id: baseid, // The baseId is being set to 1 for some reason in worldmapcell??
    },
    { populate: ["save"] }
  );

  if (!cell || !cell.save || cell.save.type === BaseType.MAIN) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1, message: "Invalid base or base type." };
    throw new Error(`Invalid base or base type. Base ID: ${baseid}`);
  }

  const { save } = cell;
  if (shiny) credits = credits - shiny;
  if (resources) savedResources = updateResources(resources, savedResources, Operation.SUBTRACT);

  // Update Save
  save.saveuserid = user.userid;
  save.name = user.username;

  if (save.type === BaseType.TRIBE) {
    save.type = BaseType.OUTPOST;
    save.buildingdata = {};
  }

  // Update Cell
  cell.base_type = MapRoomCell.OUTPOST;
  cell.uid = user.userid;

  // Update User
  outposts.push([cell.x, cell.y, baseid]);

  ORMContext.em.persistAndFlush(save);
  ORMContext.em.persistAndFlush(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
