import z from "zod";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Status } from "../../../enums/StatusCodes";
import { BaseType } from "../../../enums/Base";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { errorLog } from "../../../utils/logger";

const MigrateBaseSchema = z.object({
  type: z.string(),
  baseid: z.string().transform((baseid) => parseInt(baseid)),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

// Wiki: https://backyardmonsters.fandom.com/wiki/Jumping
export const migrateBase: KoaController = async (ctx) => {
  try {
    const { baseid, resources, shiny, type } = MigrateBaseSchema.parse(
      ctx.request.body
    );

    const currentUser: User = ctx.authUser;
    await ORMContext.em.populate(currentUser, ["save"]);

    const userSave = currentUser.save;

    // Fetch the outpost cell which the user is migrating to
    const outpostCell = await ORMContext.em.findOne(
      WorldMapCell,
      {
        base_id: baseid,
      },
      { populate: ["save"] }
    );

    // Error migrating user base: Error: Invalid base or base type. Base ID: 1005799
    // Steps: "You have moved your main yard already" popup, then try again
    if (!outpostCell ||!outpostCell.save) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error(`Invalid base or base type. Base ID: ${baseid}`);
    }

    if (shiny) userSave.credits = userSave.credits - shiny;
    if (resources)
      userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    // TODO: Handle relocate logic
    // await joinOrCreateWorld(currentUser, userSave, ORMContext.em, true);
    if (type != BaseType.OUTPOST)
      throw new Error("Relocate logic not implemented");

    // Fetch the user's homecell
    const homeCell = await ORMContext.em.findOne(WorldMapCell, {
      base_id: userSave.homebaseid,
    });

    if (!homeCell) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error("Invalid home cell");
    }

    // Update user's homebase and coordinates to the outpost cell
    userSave.homebase = [outpostCell.x.toString(), outpostCell.y.toString()];
    homeCell.x = outpostCell.x;
    homeCell.y = outpostCell.y;

    // Remove the outpost from the user's save, 3rd element in the array is the baseid
    userSave.outposts = userSave.outposts.filter((outpost) => outpost[2] !== baseid);

    // Remove baseid from building resources object
    delete userSave.buildingresources[`b${outpostCell.save.baseid}`];

    await Promise.all([
      ORMContext.em.removeAndFlush([outpostCell, outpostCell.save]),
      ORMContext.em.persistAndFlush([homeCell, userSave]),
    ]);

    const currentTime = getCurrentDateTime();
    const cantMoveTill = currentTime + 24 * 60 * 60; // 24 hours

    // TODO: Notify homecell and all outposts that outpost has been removed
    // TODO: Look at PopupLostMainBase.as and the properties it expects
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      resources: userSave.resources,
      // currenttime: currentTime,
      // cantMoveTill,
    };
  } catch (error) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    errorLog("Error migrating user base:", error);
  }
};
