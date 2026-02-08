import type { Context } from "koa";
import type { User } from "../../../../models/user.model.js";
import type { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import type { CellData } from "../../../../types/CellData.js";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
import { logger } from "../../../../utils/logger.js";

/**
 * Formats a player cell for Map Room 3
 *
 * @param ctx - Koa context with authenticated user
 * @param cell - WorldMapCell with player data
 * @param cellOwners - Pre-loaded map of user IDs to User entities
 * @returns Formatted player cell data
 */
export const playerCell = (ctx: Context, cell: WorldMapCell, cellOwners: Map<number, User>): CellData => {
  const currentUser: User = ctx.authUser;
  const mine = currentUser.userid === cell.uid;

  const cellOwner = mine ? currentUser : cellOwners.get(cell.uid);

  if (!cellOwner) logger.error(`Cell owner save data is missing for uid: ${cell.uid}`);

  const points = cellOwner.save.points;
  const basevalue = cellOwner.save.basevalue;
  const baseLevel = calculateBaseLevel(points, basevalue);

  // TODO: sort out the rest of the properties, refer to userCell.ts
  return {
    uid: cellOwner.userid,
    b: cell.base_type,
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
    rel: mine ? EnumBaseRelationship.SELF : EnumBaseRelationship.ENEMY,
    pic_square: cellOwner.pic_square,
  };
};
