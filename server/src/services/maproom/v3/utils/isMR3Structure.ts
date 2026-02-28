import { EnumYardType } from "../../../../enums/EnumYardType.js";

/**
 * Returns true if the given wmid belongs to a capturable MR3 structure
 * (RESOURCE, STRONGHOLD, or FORTIFICATION).
 *
 * These are the only types that have wmid set to their EnumYardType value
 * in tribeSaveV3. MR2 cells use tribeIndex-based wmid values and MR3 tribe
 * outposts use wmid 0, so neither will match.
 */
export const isMR3Structure = (wmid: number): boolean =>
  wmid === EnumYardType.RESOURCE ||
  wmid === EnumYardType.STRONGHOLD ||
  wmid === EnumYardType.FORTIFICATION;
