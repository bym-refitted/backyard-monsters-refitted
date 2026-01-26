import { Save } from "../../models/save.model.js";
import { User } from "../../models/user.model.js";
import type { KoaController } from "../../utils/KoaController.js";
import { postgres } from "../../server.js";
import { joinOrCreateWorld } from "../../services/maproom/v2/joinOrCreateWorld.js";
import { leaveWorld } from "../../services/maproom/v2/leaveWorld.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { Env } from "../../enums/Env.js";
import z from "zod";

/**
 * Sets the Map Room version on the server.
 */
export const CURRENT_MAPROOM_VERSION = MapRoomVersion.V2 as MapRoomVersion;

/**
 * Schema for validating the request body when setting the map version.
 */
const SetMapVersionSchema = z.object({
  version: z.string().transform((version) => parseInt(version)),
});

/**
 * Map version controller for Map Room 2 .
 * If the version is V2, the user will join a world. Otherwise, the user will leave the world.
 *
 * @param {Context} ctx - The Koa context object
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const setMapVersion: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  let save: Save = user.save;
  const { version } = SetMapVersionSchema.parse(ctx.request.body);

  if (version === MapRoomVersion.V2) {
    // Check if the user's Discord account is at least a week old
    if (!ctx.meetsDiscordAgeCheck) {
      ctx.status = Status.OK;
      ctx.body = {
        error: "Discord account is not old enough.",
      };
      return;
    }

    await joinOrCreateWorld(user, save);
  } else {
    await leaveWorld(user, save);
  }

  const filteredSave = FilterFrontendKeys(save);

  const baseurl =
    process.env.ENV === Env.PROD
      ? `${process.env.BASE_URL}/base/`
      : `${process.env.BASE_URL}:${process.env.PORT}/base/`;

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    id: filteredSave.basesaveid,
    baseurl,
    ...filteredSave,
  };
};
