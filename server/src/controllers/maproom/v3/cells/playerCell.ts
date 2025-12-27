import { Context } from "koa";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship";
import { EnumYardType } from "../../../../enums/EnumYardType";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { CellData } from "../../../../types/CellData";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { postgres } from "../../../../server";
import { User } from "../../../../models/user.model";
import { errorLog } from "../../../../utils/logger";

/**
 * Formats a player cell for Map Room 3
 *
 * @param ctx - Koa context with authenticated user
 * @param cell - WorldMapCell with player data
 * @returns Formatted player cell data
 */
export const playerCell = async (ctx: Context, cell: WorldMapCell): Promise<CellData> => {
  const cellSave = cell.save;
  const currentUser: User = ctx.authUser;
  await postgres.em.populate(currentUser, ["save"]);

  const mine = currentUser.userid === cell.uid;

  const cellOwner = mine
    ? currentUser
    : await postgres.em.findOne(
        User,
        { userid: cell.uid },
        { populate: ["save"] }
      );

  if (!cellOwner) errorLog(`Cell owner save data is missing.`);

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
