import { User } from "../../../models/user.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { postgres } from "../../../server.js";
import { createCellData } from "../../../services/maproom/v3/createCellData.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Returns the initial cell data for Map Room v3 when player opens the map.
 * Returns the player's main yard cell. Defender outposts are automatically included
 * when the player cell is requested via getcells (through getRelatedCells).
 *
 * @param {Context} ctx - Koa context with authenticated user
 * @returns {Promise<void>} Cell data response with player's main yard cell
 */
export const initialPlayerCellData: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const { worldid } = user.save;

  const homeCell = await postgres.em.findOne(WorldMapCell, {
    uid: user.userid,
    base_type: EnumYardType.PLAYER,
  });

  if (!homeCell) console.log("No MapRoom3 home found for user:", user.username);

  const cellOwners = new Map([[user.userid, user]]);
  const playerCellData = await createCellData(homeCell, worldid, ctx, cellOwners);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [playerCellData],
  };
};
