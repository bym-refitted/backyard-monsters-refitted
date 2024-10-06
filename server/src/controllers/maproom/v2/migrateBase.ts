import z from "zod";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Status } from "../../../enums/StatusCodes";
import { BaseType } from "../../../enums/Base";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { errorLog } from "../../../utils/logger";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources";
import { joinOrCreateWorld } from "../../../services/maproom/v2/joinOrCreateWorld";

// Wiki: https://backyardmonsters.fandom.com/wiki/Jumping

const MigrateBaseSchema = z.object({
  type: z.string(),
  baseid: z.string().transform((baseid) => parseInt(baseid)),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

// 24 hours
const COOLDOWN_PERIOD = 24 * 60 * 60; 

// This is currently really buggy 
// TODO: Look at PopupRelocateMe.as/PopupLostMainBase.as to see wtf is going on
export const migrateBase: KoaController = async (ctx) => {
  try {
    const { baseid, resources, shiny, type } = MigrateBaseSchema.parse(
      ctx.request.body
    );

    const currentUser: User = ctx.authUser;
    await ORMContext.em.populate(currentUser, ["save"]);

    const userSave = currentUser.save;
    const currentTime = getCurrentDateTime();

    // Check if the user is within the 24-hour cooldown period
    if (userSave.cantmovetill > currentTime) {
      ctx.status = Status.OK;
      ctx.body = {
        error: 0,
        cantMoveTill: userSave.cantmovetill,
        currenttime: currentTime,
      };
      return;
    }

    // Empire destroyed relocation
    if (type !== BaseType.OUTPOST) {
      await joinOrCreateWorld(currentUser, userSave, ORMContext.em, true);
    }

    // Fetch the outpost cell which the user is migrating to
    const outpostCell = await ORMContext.em.findOne(
      WorldMapCell,
      {
        base_id: baseid,
      },
      { populate: ["save"] }
    );

    if (!outpostCell || !outpostCell.save) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error(`Invalid base or base type. Base ID: ${baseid}`);
    }

    if (shiny) userSave.credits = userSave.credits - shiny;
    if (resources)
      userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    // Fetch the user's homecell
    const homeCell = await ORMContext.em.findOne(WorldMapCell, {
      base_id: userSave.homebaseid,
    });

    if (!homeCell) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error("Invalid home cell");
    }

    // Set the migration cooldown period before the user can move again
    userSave.cantmovetill = currentTime + COOLDOWN_PERIOD;

    // Update user's homebase and coordinates to the outpost cell
    userSave.homebase = [outpostCell.x.toString(), outpostCell.y.toString()];
    homeCell.x = outpostCell.x;
    homeCell.y = outpostCell.y;

    // Remove the outpost from the user's save, 3rd element in the array is the baseid
    userSave.outposts = userSave.outposts.filter((outpost) => outpost[2] !== baseid);

    // Remove baseid from building resources object
    delete userSave.buildingresources[`b${outpostCell.save.baseid}`];

    await Promise.all([
      ORMContext.em.removeAndFlush([outpostCell.save, outpostCell]),
      ORMContext.em.persistAndFlush([homeCell, userSave]),
    ]);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      resources: userSave.resources
    };
  } catch (error) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    errorLog("Error migrating user base:", error);
  }
};
