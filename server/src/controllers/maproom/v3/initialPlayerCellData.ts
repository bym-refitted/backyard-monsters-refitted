import { User } from "../../../models/user.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { postgres } from "../../../server.js";
import { createCellData } from "../../../services/maproom/v3/createCellData.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { logger } from "../../../utils/logger.js";

/**
 * Returns the initial cell data for Map Room v3 when player opens the map.
 *
 * Returns ALL player-owned cells (home + all outposts) so the client has the
 * complete set before BookmarksManager.Setup() runs. Without this, outposts
 * outside the initial viewport would be missing from the bookmark header count.
 *
 * The home cell (PLAYER type) is always first — the client uses celldata[0]
 * to determine the initial map center point.
 *
 * @param {Context} ctx - Koa context with authenticated user
 * @returns {Promise<void>} Cell data response with all player-owned cells
 */
export const initialPlayerCellData: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const { worldid } = user.save;

  // Fetch all player-owned cells (home + outposts) for Map Room v3
  const playerCells = await postgres.em.find(
    WorldMapCell,
    {
      uid: user.userid,
      map_version: MapRoomVersion.V3,
      world_id: worldid,
      base_type: {
        $in: [
          EnumYardType.PLAYER,
          EnumYardType.RESOURCE,
          EnumYardType.STRONGHOLD,
        ],
      },
    },
    { populate: ["save"] },
  );

  if (!playerCells.length)
    logger.info(`No MapRoom3 player cells found for user: ${user.username}`);

  const cellOwners = new Map([[user.userid, user]]);

  const celldata = await Promise.all(
    playerCells
      .sort((cell) => (cell.base_type === EnumYardType.PLAYER ? -1 : 1))
      .map((cell) => createCellData(cell, worldid, ctx, cellOwners)),
  );

  ctx.status = Status.OK;
  ctx.body = { error: 0, celldata };
};
