import z from "zod";

import { User } from "../../models/user.model.js";
import type { KoaController } from "../../utils/KoaController.js";
import { postgres } from "../../server.js";
import { joinOrCreateWorld } from "../../services/maproom/v2/joinOrCreateWorld.js";
import { leaveWorld } from "../../services/maproom/v2/leaveWorld.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { Env } from "../../enums/Env.js";
import { joinNewWorldMap } from "../../services/maproom/v3/joinNewWorldMap.js";
import { extractTownHall } from "../../utils/extractTownHall.js";
import { discordAgeErr, townHallLevelErr } from "../../errors/errors.js";

/**
 * Schema for validating the request body when setting the map version.
 */
const SetMapVersionSchema = z.object({
  version: z.string().transform((version) => parseInt(version)),
});

/**
 * Sets the player's Map Room version and performs the associated world transition.
 *
 * - NONE: Leaves the current MR2 world and clears mapversion.
 * - V1:   Sets mapversion to 1, no world ops.
 * - V2:   Requires Town Hall level 6. Joins or creates an MR2 world and marks mr2upgraded.
 * - V3:   Joins the MR3 world map.
 *
 * @param {Context} ctx - The Koa context object
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const setMapVersion: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const save = user.save!;

  const { version } = SetMapVersionSchema.parse(ctx.request.body);

  if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

  switch (version) {
    case MapRoomVersion.NONE:
      await leaveWorld(user, save);
      save.mapversion = null;
      break;

    case MapRoomVersion.V1:
      save.mapversion = MapRoomVersion.V1;
      break;

    case MapRoomVersion.V2: {
      const townHall = extractTownHall(save.buildingdata ?? {});

      if (!townHall || townHall.l < 6) throw townHallLevelErr();
      
      await joinOrCreateWorld(user, save);
      save.mr2upgraded = true;
      save.mapversion = MapRoomVersion.V2;
      break;
    }

    case MapRoomVersion.V3:
      await joinNewWorldMap(user, save);
      save.mapversion = MapRoomVersion.V3;
      break;
  }
  postgres.em.persist(save);
  await postgres.em.flush();

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
