import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection";
import { errorLog } from "../../../../utils/logger";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";

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
      : await ORMContext.em.findOne(
          User,
          { userid: cell.uid },
          { populate: ["save"] }
        );

    if (!cellOwner) errorLog(`Cell owner save data is missing.`);

    const online = getCurrentDateTime() - cellSave.savetime <= 60;

    // TODO: Cell should be locked when a player is getting attacked, not when online
    // Everytime a user cell is attacked, it trigger this for 60 seconds
    const locked = mine ? 0 : online ? 1 : cellSave.locked || 0;

    const points = BigInt(cellOwner.save.points);
    const basevalue = BigInt(cellOwner.save.basevalue);
    const baseLevel = calculateBaseLevel(points, basevalue);

    await damageProtection(cellSave);

    return {
      uid: cellOwner.userid,
      b: cell.base_type,
      pi: 0,
      bid: cell.base_id,
      aid: 0,
      i: cell.terrainHeight,
      v: cellSave.empirevalue,
      mine: mine ? 1 : 0,
      f: cellSave.flinger,
      c: cellSave.catapult,
      t: 0,
      n: cellOwner.username,
      fr: 0,
      on: online,
      p: cellSave.protected,
      r: cellSave.resources,
      m: cellSave.monsters || {},
      l: baseLevel,
      d: cellSave.damage >= 90 ? 1 : 0,
      lo: locked,
      dm: cellSave.damage,
      pic_square: currentUser.pic_square,
      im: currentUser.pic_square,
    };
  } catch (error) {
    errorLog("Error fetching user cell data", error);
  }
};
