import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { joinOrCreateWorld } from "../../../services/maproom/v2/joinOrCreateWorld";
import { leaveWorld } from "../../../services/maproom/v2/leaveWorld";
import { FilterFrontendKeys } from "../../../utils/FrontendKey";
import { MapRoomVersion } from "../../../enums/MapRoom";
import { Status } from "../../../enums/StatusCodes";
import { Env } from "../../../enums/Env";

/**
 * Sets the Map Room version on the server.
 */
export const CURRENT_MAPROOM_VERSION = MapRoomVersion.V2 as MapRoomVersion;

/**
 * Map version controller for Map Room 2 .
 * If the version is V2, the user will join a world. Otherwise, the user will leave the world.
 *
 * @param {Context} ctx - The Koa context object
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const setMapVersion: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save: Save = user.save;
  const { version } = ctx.request.body as { version: string };

  version === MapRoomVersion.V2
    ? await joinOrCreateWorld(user, save)
    : await leaveWorld(user, save);

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
