import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { STRUCTURE_SAVES, OUTPOST_SAVES } from "../../../config/MapRoom3Config.js";
import { Tribes } from "../../../enums/Tribes.js";
import { getGeneratedCells, cellKey } from "./generateCells.js";
import { calculateStructureLevel } from "./calculateStructureLevel.js";

/**
 * Generates a Save entity for an MR3 procedural structure (stronghold, resource,
 * defender, or tribe outpost) from its baseid.
 *
 * Extracts cell coordinates from the baseid, looks up the structure type from
 * the generated cell cache, then resolves the appropriate save data template:
 *
 * Outposts and Defenders: Use pre-computed levels assigned during world generation.
 *   Outposts are tribe-specific, looked up via OUTPOST_SAVES[tribeIndex][level].
 *   wmid is set to 0 so the client treats the base as a main yard.
 * 
 * Strongholds/Resources: Use deterministic level calculation from coordinates.
 *
 * @param {string} baseid - The base ID encoding world hash and cell coordinates
 * @returns {Save | null} A new Save entity for the structure, or null if the
 *   cell type has no associated save data
 */
export const tribeSaveV3 = (baseid: string): Save | null => {
  const cellX = parseInt(baseid.slice(-6, -3));
  const cellY = parseInt(baseid.slice(-3));

  const genCell = getGeneratedCells().get(cellKey(cellX, cellY));
  const structureType = genCell?.type;

  if (structureType === EnumYardType.OUTPOST) {
    const tribeIndex = (cellX + cellY) % Tribes.length;

    const level = genCell.level;
    const outpostSave = OUTPOST_SAVES[tribeIndex][level];

    if (!outpostSave) return null;

    return postgres.em.create(Save, {
      ...outpostSave,
      baseid,
      level,
      wmid: 0,
    });
  }

  const tribeSave = STRUCTURE_SAVES[structureType];

  if (!tribeSave) return null;

  // Defenders use pre-computed levels from generation, others are derived from coordinates
  const isFortification = structureType === EnumYardType.FORTIFICATION;

  const level = isFortification ? genCell.level : calculateStructureLevel(cellX, cellY, structureType);

  return postgres.em.create(Save, {
    ...tribeSave[level],
    baseid,
    level,
    wmid: structureType,
  });
};
