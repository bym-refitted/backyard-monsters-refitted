import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { errorLog } from "../../../../utils/logger";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";

/** TODO: cellOwner.save is null in many cases here */

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
  const cellSave = cell.save;
  const currentUser: User = ctx.authUser;
  await ORMContext.em.populate(currentUser, ["save"]);

  try {
    const mine = currentUser.userid === cell.uid;

    // Get the cell owner, either the current user or another user
    const cellOwner = mine
      ? currentUser
      : await ORMContext.em.findOne(User, { userid: cell.uid });

    if (!cellOwner || !cellOwner.save) {
      errorLog(`Cell owner save data is missing. Save: ${cellOwner.save}`);
    }

    const isOnline = getCurrentDateTime() - (cellOwner.save?.savetime || 0) <= 60;

    /** TODO: Cell should be locked when a player is getting attacked, not when online */
    const locked = mine ? 0 : isOnline ? 1 : cellOwner.save?.locked || 0;

    const points = cellOwner.save?.points
      ? BigInt(cellOwner.save.points)
      : BigInt(1);
    const basevalue = cellOwner.save?.basevalue
      ? BigInt(cellOwner.save.basevalue)
      : BigInt(1);

    const baseLevel = calculateBaseLevel(points, basevalue);

    let isCellProtected = await damageProtection(cellSave);

    if (!cellSave) errorLog("Cell save data is missing.");

    return {
      uid: cellOwner.userid,
      b: cell.base_type,
      pi: 0,
      bid: cell.base_id,
      aid: 0,
      i: cell.terrainHeight,
      v: cellSave?.empirevalue || 1,
      mine: mine ? 1 : 0,
      f: cellSave?.flinger || 0,
      c: cellSave?.catapult || 0,
      t: 0,
      n: cellOwner.username,
      fr: 0,
      on: isOnline,
      p: isCellProtected,
      r: cellOwner.save.resources,
      m: cellSave?.monsters || {},
      l: baseLevel,
      d: cellSave?.damage >= 90 ? 1 : 0 || 0,
      lo: locked,
      dm: cellSave?.damage || 0,
      pic_square: `${process.env.AVATAR_URL}?seed=${cellOwner.username}`,
      im: `${process.env.AVATAR_URL}?seed=${cellOwner.username}`,
    };
  } catch (error) {
    errorLog("Error fetching user cell data", error);
  }
};
