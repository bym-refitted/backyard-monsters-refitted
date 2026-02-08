import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { STRUCTURE_SAVES } from "../../../config/MapRoom3Config.js";
import { getGeneratedCells } from "./generateCells.js";
import { calculateStructureLevel } from "./calculateStructureLevel.js";

/**
 * Generates a Save for an MR3 wild monster structure based on baseid.
 *
 * Extracts coordinates from the baseid, looks up the structure type from
 * the generated cell cache, and returns the matching data file entry.
 * Returns null if the cell type has no associated save data.
 *
 * @param {string} baseid - The base ID (15 digits: [3][worldHash:8][X:3][Y:3])
 * @returns {Save | null} A new Save entity for the wild monster structure, or null
 */
export const tribeSaveV3 = (baseid: string): Save | null => {
  const cellX = parseInt(baseid.slice(-6, -3));
  const cellY = parseInt(baseid.slice(-3));

  const genCell = getGeneratedCells().get(`${cellX},${cellY}`);
  const structureType = genCell?.type;

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
