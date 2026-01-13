import { FieldData } from "../models/save.model.js";

export interface TownHall {
  id: number;
  l: number;
  x: number;
  y: number;
  t: number;
  fort: number;
  cU: number;
}

/**
 * Returns the Town Hall building object contained in the given buildingData object.
 * Throws an error if the town hall cannot be found.
 *
 * The object is identified by checking the `t` (type) variable on the child objects.
 * If `t` is equal to 14, then it is considered a Town Hall.
 *
 * @param buildingData the buildingData object to search
 * @returns the townHall object found or null if not found
 * @throws Error when townHall Object cannot be found
 */
export const extractTownHall = (buildingData: FieldData): TownHall | null => {
  for (const key in buildingData) {
    const building = buildingData[key];

    if (building && building.t === 14) return building;
  }
  return null;
};
