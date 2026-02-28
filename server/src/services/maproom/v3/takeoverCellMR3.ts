import { BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { postgres } from "../../../server.js";
import {
  RESOURCE_CAPACITIES,
  RESOURCE_PRODUCTION_RATES,
  STRONGHOLD_BONUSES,
  STRUCTURE_RANGE,
} from "../../../config/MapRoom3Config.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { cellKey, getGeneratedCells } from "./generateCells.js";
import { getHexNeighborOffsets } from "./getHexNeighborOffsets.js";
import { isMR3Structure } from "./utils/isMR3Structure.js";
import { logger } from "../../../utils/logger.js";

interface ResourceTakeover {
  level: number;
  productionRate: number;
  capacity: number;
  range: number;
}

interface StrongholdTakeover {
  level: number;
  monsterBonus: number;
  towerBonus: number;
  range: number;
}

interface FortificationTakeover {
  level: number;
  fortified?: number;
  weakened?: number;
}

export type TakeoverData = ResourceTakeover | StrongholdTakeover | FortificationTakeover;
export type TakeoverResult = Promise<TakeoverData | null>;

/**
 * Processes an MR3 takeover when a tribe/WM base is captured (damage >= 90, over = 1).
 *
 * Transfers cell ownership to the attacking player, updates the Save and WorldMapCell,
 * adds the cell to the user's outposts, and returns the takeover data object for the
 * client's MapRoom3OutpostSecured popup.
 *
 * Only processes V3 cells - returns null for non-MR3 saves to avoid conflicting with
 * the MR2 explicit takeoverCell endpoint.
 *
 * @param {Save} baseSave - The captured tribe base save
 * @param {User} user - The attacking user
 * @param {Save} userSave - The attacking user's home save
 * @returns {Promise<TakeoverData | null>} Takeover data for the response, or null
 */
export const takeoverCellMR3 = async (baseSave: Save, user: User, userSave: Save): TakeoverResult => {
  const { baseid, wmid, level } = baseSave;

  if (!isMR3Structure(wmid)) return null;

  const cell = await postgres.em.findOne(WorldMapCell, { baseid });

  if (!cell) {
    logger.error(`WorldMapCell not found for baseid: ${baseid}`);
    return null;
  }

  // Transfer ownership of the save
  baseSave.saveuserid = user.userid;
  baseSave.userid = userSave.userid;
  baseSave.homebaseid = userSave.homebaseid;
  baseSave.name = userSave.name;
  baseSave.type = BaseType.OUTPOST;
  baseSave.damage = 0;
  baseSave.resources = {};
  baseSave.monsters = {};
  baseSave.attacks = [];
  baseSave.createtime = getCurrentDateTime();
  baseSave.takeoverDate = new Date();

  // Clean up previous owner's save if the cell was player-owned
  const previousOwner = await postgres.em.findOne(
    User,
    { userid: baseSave.saveuserid },
    { populate: ["save"] },
  );

  if (previousOwner?.save) {
    const { outposts } = previousOwner.save;
    
    previousOwner.save.outposts = outposts.filter(
      ([x, y, id]) => !(x === cell.x && y === cell.y && id === baseid),
    );

    delete previousOwner.save.buildingresources[`b${baseid}`];

    await postgres.em.persistAndFlush(previousOwner);
  }

  // Update world map cell
  cell.uid = user.userid;
  cell.base_type = wmid;

  userSave.outposts.push([cell.x, cell.y, baseSave.baseid]);
  await postgres.em.persistAndFlush([cell, userSave]);

  switch (wmid) {
    case EnumYardType.RESOURCE:
      return {
        level,
        productionRate: RESOURCE_PRODUCTION_RATES[level],
        capacity: RESOURCE_CAPACITIES[level],
        range: STRUCTURE_RANGE[EnumYardType.RESOURCE][level],
      };

    case EnumYardType.STRONGHOLD:
      return {
        level,
        monsterBonus: STRONGHOLD_BONUSES[level],
        towerBonus: STRONGHOLD_BONUSES[level],
        range: STRUCTURE_RANGE[EnumYardType.STRONGHOLD][level],
      };

    case EnumYardType.FORTIFICATION: {
      const cells = getGeneratedCells();

      for (const [dx, dy] of getHexNeighborOffsets(cell.y)) {
        const neighbor = cells.get(cellKey(cell.x + dx, cell.y + dy));

        if (!neighbor) continue;

        if (neighbor.type === EnumYardType.RESOURCE || neighbor.type === EnumYardType.STRONGHOLD) {
          return { level, fortified: neighbor.type };
        }
      }

      return { level, weakened: EnumYardType.RESOURCE };
    }
  }
};
