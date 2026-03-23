import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import {
  STRUCTURE_SAVES,
  OUTPOST_SAVES,
} from "../../../config/MapRoom3Config.js";
import { Tribes } from "../../../enums/Tribes.js";
import { getGeneratedCells, cellKey } from "./generateCells.js";
import { calculateStructureLevel } from "./calculateStructureLevel.js";
import { getDefenderCoords } from "./getDefenderCoords.js";
import { getDefenderLevels } from "./getDefenderLevels.js";
import { getHexNeighborOffsets } from "./getHexNeighborOffsets.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";

/**
 * Generates a Save entity for an MR3 procedural structure (stronghold, resource,
 * defender, or tribe outpost) from its baseid.
 *
 * Resolution priority:
 *
 * 1. Player yard defenders: checked first via a DB query for an adjacent PLAYER
 *    yard. Player yards are dynamic, so their defender positions are not in the generated cache
 *
 * 2. Generated OUTPOST: tribe-specific save looked up via OUTPOST_SAVES.
 *    wmid encodes the tribe (tribeIndex * 10 + 1) so the client resolves
 *    L_IDS/K_IDS/A_IDS/D_IDS correctly.
 *
 * 3. Generated structure (STRONGHOLD, RESOURCE, FORTIFICATION): deterministic
 *    level from coordinates, save from STRUCTURE_SAVES.
 *
 * @param {string} baseid - The base ID encoding world hash and cell coordinates
 * @param {string} worldid - The world UUID, used to scope the player yard DB lookup
 * @returns {Promise<Save | null>} A new Save entity for the structure, or null
 */
export const tribeSaveV3 = async (baseid: string, worldid: string): Promise<Save | null> => {
  const cellX = parseInt(baseid.slice(-6, -3));
  const cellY = parseInt(baseid.slice(-3));

  // Check player yard defenders first.
  const neighborCoords = getHexNeighborOffsets(cellY).map(([dx, dy]) => ({
    x: cellX + dx,
    y: cellY + dy,
  }));

  const parentCell = await postgres.em.findOne(WorldMapCell, {
    $and: [
      { $or: neighborCoords },
      {
        world_id: worldid,
        base_type: EnumYardType.PLAYER,
        uid: { $gt: 0 },
        map_version: MapRoomVersion.V3,
      },
    ],
  });

  if (parentCell) {
    const defenderCoords = getDefenderCoords(parentCell.x, parentCell.y);
    const defenderIndex = defenderCoords.findIndex(([fx, fy]) => fx === cellX && fy === cellY);

    if (defenderIndex >= 0) {
      const defenderLevels = getDefenderLevels(EnumYardType.PLAYER);
      const level = defenderLevels[defenderIndex];
      const defenderSave = STRUCTURE_SAVES[EnumYardType.FORTIFICATION];

      return postgres.em.create(Save, {
        ...defenderSave[level],
        baseid,
        level,
        wmid: EnumYardType.FORTIFICATION,
      });
    }
  }

  const genCell = getGeneratedCells().get(cellKey(cellX, cellY));
  const structureType = genCell?.type;

  if (structureType === EnumYardType.OUTPOST) {
    const tribeIndex = (cellX + cellY) % Tribes.length;
    const level = genCell.level;
    const outpostSave = OUTPOST_SAVES[tribeIndex][level];

    if (!outpostSave) return null;

    // Client uses wmid to look up the tribe via TRIBES.TribeForBaseID(_wmID).
    // L_IDS/K_IDS/A_IDS/D_IDS start at 1/11/21/31, so tribeIndex * 10 + 1
    // gives the first nid of each tribe's range and resolves correctly.
    const wmid = tribeIndex * 10 + 1;

    return postgres.em.create(Save, {
      ...outpostSave,
      baseid,
      level,
      wmid,
    });
  }

  if (structureType !== undefined) {
    const tribeSave = STRUCTURE_SAVES[structureType];

    if (!tribeSave) return null;

    const isFortification = structureType === EnumYardType.FORTIFICATION;
    const level = isFortification
      ? genCell.level
      : calculateStructureLevel(cellX, cellY, structureType);

    return postgres.em.create(Save, {
      ...tribeSave[level],
      baseid,
      level,
      wmid: structureType,
    });
  }

  return null;
};