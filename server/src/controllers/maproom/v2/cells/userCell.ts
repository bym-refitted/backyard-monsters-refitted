import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { BaseType } from "../../../../enums/Base";

/**
 * Handles the user's homecell & outpost data on the world map.
 *
 * Retrives the current user's homecell details if the cell belongs to them.
 * Otherwise, retrieves the homecell details of all other users on the world map.
 * Data for a homeCell comes from both the world map cell and the user's save data.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {WorldMapCell} cell - The world map cell object.
 */
export const userCell = async (ctx: Context, cell: WorldMapCell) => {
  const { save } = cell;
  if (!save) throw new Error("This cell does not have a user save.");

  const currentUser: User = ctx.authUser;
  const mine = currentUser.userid === cell.uid;

  // Get the cell owner, either the current user or another user
  const cellOwner = mine
    ? currentUser
    : await ORMContext.em.findOne(User, { userid: cell.uid });

  const isOnline = Date.now() / 1000 - save.savetime < 30;

  /** TODO: Cell should be locked when a player is getting attacked, not when online */
  const locked = mine ? 0 : isOnline ? 1 : save.locked;
  const baseLevel = calculateBaseLevel(save.points, save.basevalue);
  let isCellProtected = save.protected;

  /** TODO: https://backyardmonsters.fandom.com/wiki/Damage_Protection */
  if (save.type === BaseType.MAIN && save.damage >= 50) isCellProtected = 1;

  return {
    uid: cellOwner.userid,
    b: cell.base_type,
    fbid: save.fbid,
    pi: 0,
    bid: cell.base_id,
    aid: 0,
    i: cell.terrainHeight,
    mine: mine ? 1 : 0,
    f: save.flinger,
    c: save.catapult,
    t: 0,
    n: cellOwner.username,
    fr: 0,
    on: isOnline,
    p: isCellProtected,
    r: save.resources,
    m: save.monsters,
    l: baseLevel,
    d: save.damage > 90,
    lo: locked,
    dm: save.damage,
    pic_square: `https://api.dicebear.com/9.x/miniavs/png?seed=${cellOwner.username}`,
    im: `https://api.dicebear.com/9.x/miniavs/png?seed=${cellOwner.username}`,
  };
};
