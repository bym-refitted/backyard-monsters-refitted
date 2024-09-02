import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { BaseType } from "../../../../enums/Base";

/**
 * Handles the user's homecell data on the world map.
 *
 * Retrives the current user's homecell details if the cell belongs to them.
 * Otherwise, retrieves the homecell details of all other users on the world map.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {WorldMapCell} cell - The world map cell object.
 */
export const homeCell = async (ctx: Context, cell: WorldMapCell) => {
  if (!cell.save) throw new Error("There is no save for the user cell");
  const currentUser: User = ctx.authUser;
  const mine = currentUser.userid === cell.uid;

  // // Get the cell owner, either the current user or another user
  const cellOwner = mine
    ? currentUser
    : await ORMContext.em.findOne(User, { userid: cell.uid });

  const isOnline = Date.now() / 1000 - cell.save.savetime < 30;
  const locked = isOnline ? 1 : cell.save.locked;
  const baseLevel = calculateBaseLevel(cell.save.points, cell.save.basevalue);
  let isCellProtected = cell.save.protected;

  /** TODO: https://backyardmonsters.fandom.com/wiki/Damage_Protection */
  if (cell.save.type === BaseType.MAIN && cell.save.damage >= 50)
    isCellProtected = 1;

  return {
    uid: cellOwner.userid,
    b: cell.base_type,
    fbid: cell.save.fbid,
    pi: 0,
    bid: cell.base_id,
    aid: 0,
    i: cell.terrainHeight,
    mine: mine ? 1 : 0,
    f: cell.save.flinger,
    c: cell.save.catapult,
    t: 0,
    n: cellOwner.username,
    fr: 0,
    on: isOnline,
    p: isCellProtected,
    r: cell.save.resources,
    m: cell.save.monsters,
    l: baseLevel,
    d: cell.save.damage > 90,
    lo: locked,
    dm: cell.save.damage,
    pic_square: `https://api.dicebear.com/9.x/miniavs/png?seed=${cellOwner.username}`,
    im: `https://api.dicebear.com/9.x/miniavs/png?seed=${cellOwner.username}`,
  };
};
