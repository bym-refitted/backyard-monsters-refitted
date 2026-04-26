export interface BuildingData {
  x: number;              // x position
  y: number;              // y position
  t: number;              // building type
  id: number;             // building ID
  l?: number;             // current level
  fort?: number;          // fortification level
  cB?: number;            // countdown build
  cU?: number;            // countdown upgrade
  prefab?: number;        // kit type for outpost buildings
  [key: string]: unknown; // allow for future expansion without breaking type safety
}
