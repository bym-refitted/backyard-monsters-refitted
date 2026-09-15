import type { BuildingHealthData } from "./BuildingData.js";

export interface TribeData {
  baseid: string;
  tribeHealthData: BuildingHealthData;
  monsters?: Record<string, number>;
  destroyed?: number;
  destroyedAt?: number;
}
