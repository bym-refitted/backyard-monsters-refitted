import type { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { EnumYardType } from "../../../../enums/EnumYardType.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import type { CellData } from "../../../../types/CellData.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
import { postgres } from "../../../../server.js";
import { User } from "../../../../models/user.model.js";
import { logger } from "../../../../utils/logger.js";

/**
 * Formats a player cell for Map Room 3
 *
 * @param ctx - Koa context with authenticated user
 * @param cell - WorldMapCell with player data
 * @returns Formatted player cell data
 */
export const playerCell = async (ctx: Context, cell: WorldMapCell): Promise<CellData> => {
  const currentUser: User = ctx.authUser;
  const mine = currentUser.userid === cell.uid;

  const cellOwner = mine
    ? currentUser
    : await postgres.em.findOne(
        User,
        { userid: cell.uid },
        { populate: ["save"] }
      );

  if (!cellOwner) logger.error(`Cell owner save data is missing.`);

  const points = cellOwner.save.points;
  const basevalue = cellOwner.save.basevalue;
  const baseLevel = calculateBaseLevel(points, basevalue);

  // TODO: sort out the rest of the properties, refer to userCell.ts
  return {
    uid: cellOwner.userid,
    b: EnumYardType.PLAYER,
    bid: cell.baseid,
    n: cellOwner.username,
    tid: 0,
    x: cell.x,
    y: cell.y,
    i: cell.terrainHeight,
    l: baseLevel,
    fbid: "",
    pl: 0,
    r: 10,
    dm: 0,
    lo: 0,
    fr: 0,
    p: 0,
    d: 0,
    t: 0,
    rel: EnumBaseRelationship.SELF,
    pic_square: cellOwner.pic_square,
  };
};
