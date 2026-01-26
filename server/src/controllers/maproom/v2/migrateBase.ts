import type { KoaController } from "../../../utils/KoaController.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { BaseType } from "../../../enums/Base.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { logger } from "../../../utils/logger.js";
import {
  Operation,
  updateResources,
} from "../../../services/base/updateResources.js";
import { joinOrCreateWorld } from "../../../services/maproom/v2/joinOrCreateWorld.js";
import { leaveWorld } from "../../../services/maproom/v2/leaveWorld.js";
import { MapRoomCell } from "../../../enums/MapRoom.js";
import { relocateOutpostErr } from "../../../errors/errors.js";
import { ClientSafeError } from "../../../middleware/clientSafeError.js";
import { MigrateBaseSchema } from "../../../zod/MigrateBaseSchema.js";

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
    const { baseid, resources, shiny, type } = MigrateBaseSchema.parse(ctx.request.body);

    const currentUser: User = ctx.authUser;
    await postgres.em.populate(currentUser, ["save"]);

    const userSave = currentUser.save;
    const currentTime = getCurrentDateTime();

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

    // User is relocating due to their empire being overrun.
    if (type === BaseType.RANDOM) {
      if (userSave.outposts.length > 0) throw relocateOutpostErr();

      await leaveWorld(currentUser, userSave);
      await joinOrCreateWorld(currentUser, userSave, postgres.em, true);

      ctx.status = Status.OK;
      ctx.body = { error: 0 };
      return;
    }

    // Otherwise, fetch the outpost cell (destination) and the user's homeCell (origin) for migration.
    const cells = await postgres.em.find(
      WorldMapCell,
      {
        baseid: { $in: [baseid, userSave.baseid] },
      },
      { populate: ["save"] }
    );

    const outpostCell = cells.find((cell) => cell.baseid === baseid);

    const homeCell = cells.find(
      (cell) =>
        cell.baseid === userSave.baseid &&
        cell.base_type === MapRoomCell.HOMECELL
    );

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
    // Store outpost details before removing it
    const [outpostX, outpostY] = [outpostCell.x, outpostCell.y];
    const outpostHeight = outpostCell.terrainHeight;
    const outpostBaseId = outpostCell.save.baseid;

    // Update the user's homecell coordinates to the outpost cell
    homeCell.x = outpostX;
    homeCell.y = outpostY;
    homeCell.terrainHeight = outpostHeight;

    // Update user's homebase coordinates to the outpost cell
    userSave.homebase = [outpostX.toString(), outpostY.toString()];

    // Set the migration cooldown period before the user can move again
    userSave.cantmovetill = currentTime + COOLDOWN_PERIOD;

    // Remove the outpost from the user's save, 3rd element in the array is the baseid
    userSave.outposts = userSave.outposts.filter(
      (outpost) => outpost[2] !== baseid
    );

    // Remove baseid from building resources object
    delete userSave.buildingresources[`b${outpostBaseId}`];

    if (shiny) userSave.credits = userSave.credits - shiny;
    if (resources)
      userSave.resources = updateResources(resources, userSave.resources, Operation.SUBTRACT);

    await postgres.em.transactional(async (em) => {
      await em.persistAndFlush([homeCell, userSave]);
      await em.removeAndFlush([outpostCell.save, outpostCell]);
    });

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      coords: [outpostX, outpostY],
    };
  } catch (error) {
    if (error instanceof ClientSafeError) throw error;

    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    logger.error("Error migrating user base:", error);
  }
};
