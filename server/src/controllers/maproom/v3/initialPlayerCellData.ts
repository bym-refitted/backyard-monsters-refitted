import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { EnumYardType } from "../../../enums/EnumYardType";
import { postgres } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { createCellData } from "../../../services/maproom/v3/createCellData";

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

  const homeCell = await postgres.em.findOne(WorldMapCell, {
    uid: user.userid,
    base_type: EnumYardType.PLAYER,
  });

  if (!homeCell) console.log("No MapRoom3 home found for user:", user.username);

  const celldata = [];

  const playerCellData = await createCellData(homeCell, ctx);
  celldata.push(playerCellData);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata,
  };
};
