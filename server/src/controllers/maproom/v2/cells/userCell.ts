import type { Context } from "koa";
import type { User } from "../../../../models/user.model.js";
import type { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
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
 * @param {Map<number, User>} cellOwners - Pre-loaded map of user IDs to User entities.
 */
export const userCell = async (ctx: Context, cell: WorldMapCell, cellOwners: Map<number, User>) => {
  const cellSave = cell.save;
  const currentUser: User = ctx.authUser;

  try {
    const mine = currentUser.userid === cell.uid;

    // Get the cell owner, either the current user or another user
    const cellOwner = mine ? currentUser : cellOwners.get(cell.uid);

    if (!cellOwner?.save || !cellSave) {
      logger.error(`Cell owner save data is missing.`);
      return;
    }

    const currentTime = getCurrentDateTime();

    // locked stores the attacker's user ID when a base is actively under attack (set by the attack system)
    const locked = mine ? 0 : cellSave.locked || 0;

    const points = cellOwner.save.points;
    const basevalue = cellOwner.save.basevalue;
    const baseLevel = calculateBaseLevel(points, basevalue);

    const isProtected = cellSave.protected > 0 && cellSave.protected > currentTime;
    const protectionExpired = cellSave.protected > 0 && cellSave.protected <= currentTime;
    
    const damage = protectionExpired ? 0 : cellSave.damage;

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
      p: isProtected ? 1 : 0, // Convert timestamp to boolean for client
      r: cellSave.resources,
      m: cellSave.monsters || {},
      l: baseLevel,
      d: damage >= 90 ? 1 : 0,
      lo: locked,
      dm: damage,
      pic_square: cellOwner.pic_square,
      im: cellOwner.pic_square
    };
  } catch (error) {
    logger.error(`Error fetching user cell data: ${error}`);
  }
};
