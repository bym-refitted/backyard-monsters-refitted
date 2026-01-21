import { Context } from "koa";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection.js";
import { logger } from "../../../../utils/logger.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";

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
  await postgres.em.populate(currentUser, ["save"]);

  try {
    const mine = currentUser.userid === cell.uid;

    // Get the cell owner, either the current user or another user
    const cellOwner = mine
      ? currentUser
      : await postgres.em.findOne(
          User,
          { userid: cell.uid },
          { populate: ["save"] }
        );

    if (!cellOwner) logger.error(`Cell owner save data is missing.`);

    const online = getCurrentDateTime() - cellSave.savetime <= 60;

    // TODO: Cell should be locked when a player is getting attacked, not when online
    // Everytime a user cell is attacked, it trigger this for 60 seconds
    const locked = mine ? 0 : online ? 1 : cellSave.locked || 0;

    const points = cellOwner.save.points;
    const basevalue = cellOwner.save.basevalue;
    const baseLevel = calculateBaseLevel(points, basevalue);

    await damageProtection(cellSave);

    const currentTime = getCurrentDateTime();
    const isProtected = cellSave.protected > 0 && cellSave.protected > currentTime;

    return {
      uid: cellOwner.userid,
      b: cell.base_type,
      pi: 0,
      bid: cell.baseid,
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
      p: isProtected ? 1 : 0, // Convert timestamp to boolean for client
      r: cellSave.resources,
      m: cellSave.monsters || {},
      l: baseLevel,
      d: cellSave.damage >= 90 ? 1 : 0,
      lo: locked,
      dm: cellSave.damage,
      pic_square: cellOwner.pic_square,
      im: cellOwner.pic_square
    };
  } catch (error) {
    logger.error("Error fetching user cell data", error);
  }
};
