import type { Context } from "koa";
import type { User } from "../../../../models/user.model.js";
import type { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import type { CellData } from "../../../../types/CellData.js";
import { EnumBaseRelationship } from "../../../../enums/EnumBaseRelationship.js";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel.js";
import { PLAYER_RANGE, STRUCTURE_RANGE } from "../../../../config/MapRoom3Config.js";
import { EnumYardType } from "../../../../enums/EnumYardType.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import { isAttackActive } from "../../../../services/base/isAttackActive.js";

/**
 * Handles the player's cell data on the world map for Map Room v3.
 *
 * Retrieves the current player's cell details if the cell belongs to them.
 * Otherwise, retrieves the cell details of other players on the world map.
 * Data for a player cell comes from both the world map cell and the player's save data.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {WorldMapCell} cell - The world map cell object.
 * @param {Map<number, User>} cellOwners - Pre-loaded map of user IDs to User entities.
 */
export const playerCell = async (ctx: Context, cell: WorldMapCell, cellOwners: Map<number, User>): Promise<CellData> => {
  const [cellX, cellY] = [cell.x, cell.y];

  const currentUser: User = ctx.authUser;
  const { lastSeen = new Map(), truces } = ctx.state;

  const mine = currentUser.userid === cell.uid;
  const cellOwner = mine ? currentUser : cellOwners.get(cell.uid);

  const cellSave = cell.save;

  // We render an empty cell if the owner is not found or doesn't have save data
  if (!cellSave || !cellOwner?.save) return { x: cell.x, y: cell.y, i: 0 };

  const points = cellOwner.save.points;
  const basevalue = cellOwner.save.basevalue;

  const playerLevel = calculateBaseLevel(points, basevalue);
  const structureLevel = cellSave.level ?? 0;

  const structureRange = STRUCTURE_RANGE[cell.base_type];

  let range = 0;

  if (structureRange) {
    range = structureRange[structureLevel];
  } else if (cell.base_type === EnumYardType.PLAYER) {
    range = PLAYER_RANGE;
  }

  const altitude = 5 + (cellX * 73 + cellY * 31) % 45;

  const currentTime = getCurrentDateTime();
  const homeCell = cell.base_type === EnumYardType.PLAYER;

  let isProtected = false;

  if (homeCell) 
    isProtected = cellSave.protected > 0 && cellSave.protected > currentTime;

  const online = homeCell && (lastSeen.get(cell.uid) ?? 0) >= currentTime - 60;
  const isUnderAttack = homeCell && isAttackActive(cellSave);

  let locked = 0;
  if (online || isUnderAttack) locked = 1;
  if (mine) locked = 0;

  const hasTruce = !mine && !!truces.get(cellOwner.userid);

  return {
    uid: cellOwner.userid,
    b: cell.base_type,
    bid: cell.baseid,
    n: cellOwner.username,
    tid: 0,
    x: cell.x,
    y: cell.y,
    i: altitude,
    l: cell.base_type !== EnumYardType.PLAYER ? (structureLevel ?? playerLevel) : playerLevel,
    fbid: "",
    pl: 0,
    r: range,
    dm: cellSave?.damage ?? 0,
    lo: locked,
    fr: 0,
    p: isProtected ? 1 : 0,
    d: (cellSave?.damage ?? 0) >= 90 ? 1 : 0,
    t: hasTruce ? 1 : 0,
    rel: mine ? EnumBaseRelationship.SELF : EnumBaseRelationship.ENEMY,
    pic_square: cellOwner.pic_square ?? undefined,
  };
};
