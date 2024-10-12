import z from "zod";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Status } from "../../../enums/StatusCodes";
import { BaseMode, BaseType } from "../../../enums/Base";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";
import { errorLog, logging } from "../../../utils/logger";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources";
import { joinOrCreateWorld } from "../../../services/maproom/v2/joinOrCreateWorld";

/**
 * Request schema for migrate base.
 */
const MigrateBaseSchema = z.object({
  type: z.nativeEnum(BaseType),
  baseid: z.string(),
  resources: z.string().transform((res) => JSON.parse(res)).optional(),
  shiny: z.string().transform((shiny) => parseInt(shiny)).optional(),
});

/**
 * Cooldown period for base migration.
 * @constant {number}
 */
const COOLDOWN_PERIOD = 24 * 60 * 60;

/**
 * Handles user base migration.
 *
 * This controller allows a user to migrate their base to a new location.
 * It checks if the user is within the cooldown period, validates the base being migrated to
 * and relocates their home base. If the migration is successful, the user's cooldown is updated
 * and the new home base is saved.
 *
 * @param {Object} ctx - The Koa context object
 * @returns {Promise<void>} A promise that resolves once the base migration is complete.
 *
 * @throws Will throw an error if the base type is invalid, no homebase is found or if it catches an exception.
 */
export const migrateBase: KoaController = async (ctx) => {
  try {
    const { baseid, resources, shiny, type } = MigrateBaseSchema.parse(
      ctx.request.body
    );

    const currentUser: User = ctx.authUser;
    await ORMContext.em.populate(currentUser, ["save"]);

    const userSave = currentUser.save;
    const currentTime = getCurrentDateTime();

    if (shiny) userSave.credits = userSave.credits - shiny;
    if (resources) userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    // Check if the user is within the cooldown period.
    if (userSave.cantmovetill > currentTime) {
      ctx.status = Status.OK;
      ctx.body = {
        error: 0,
        cantMoveTill: userSave.cantmovetill,
        currenttime: currentTime,
      };
      return;
    }

    // Check if the user is relocating due to their empire being overrun.
    if (type !== BaseType.OUTPOST && baseid === BaseMode.DEFAULT) {
      await joinOrCreateWorld(currentUser, userSave, ORMContext.em, true);
      ctx.status = Status.OK;
      ctx.body = { error: 0 };
      return;
    }

    // Otherwise, fetch the outpost cell (destination) and the user's homeCell (origin) for migration.
    const cells = await ORMContext.em.find(
      WorldMapCell,
      {
        base_id: { $in: [parseInt(baseid), userSave.homebaseid] },
      },
      { populate: ["save"] }
    );

    const outpostCell = cells.find((cell) => cell.base_id === parseInt(baseid));
    const homeCell = cells.find((cell) => cell.base_id === userSave.homebaseid);

    if (!outpostCell || !outpostCell.save) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error(`Invalid base or base type. Base ID: ${baseid}`);
    }

    if (!homeCell) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: 1 };
      throw new Error("Invalid home cell");
    }

    // Update the user's homecell coordinates to the outpost cell
    homeCell.x = outpostCell.x;
    homeCell.y = outpostCell.y;
    homeCell.terrainHeight = outpostCell.terrainHeight;

    // Update user's homebase coordinates to the outpost cell
    userSave.homebase = [outpostCell.x.toString(), outpostCell.y.toString()];

    // Set the migration cooldown period before the user can move again
    userSave.cantmovetill = currentTime + COOLDOWN_PERIOD;

    // Remove the outpost from the user's save, 3rd element in the array is the baseid
    userSave.outposts = userSave.outposts.filter((outpost) => 
      outpost[2] !== parseInt(baseid)
    );

    // Remove baseid from building resources object
    delete userSave.buildingresources[`b${outpostCell.save.baseid}`];

    await ORMContext.em.removeAndFlush([outpostCell.save, outpostCell]);
    await ORMContext.em.persistAndFlush([homeCell, userSave]);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      coords: [outpostCell.x, outpostCell.y]
    };
  } catch (error) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    errorLog("Error migrating user base:", error);
  }
};
