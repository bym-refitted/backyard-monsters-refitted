export interface BuildingData {
  x: number;              // x position
  y: number;              // y position
  t: number;              // building type
  id: number;             // building ID
  l?: number;             // current level
  fort?: number;          // fortification level
  cB?: number;            // countdown build
  cU?: number;            // countdown upgrade
  cF?: number;            // countdown fortify
  hp?: number;            // health, only when damaged (not written on MR3)
  rE?: number;            // repairing flag
  prefab?: number;        // kit type for outpost buildings
  [key: string]: unknown; // allow for future expansion without breaking type safety
}

/**
 * A base's buildingdata column: every building on the base, keyed by building id.
 */
export type BuildingDataMap = Record<string, BuildingData>;

/**
 * A base's buildinghealthdata column: current health keyed by building id.
 * The client only writes buildings below full health, and 0 for traps that have fired.
 */
export type BuildingHealthData = Record<string, number>;