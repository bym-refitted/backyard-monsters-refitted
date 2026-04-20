import type { TribeScaleConfig } from "../services/maproom/inferno/createInfernoTribes.js";
import type { MR1TribeScaleConfig } from "../services/maproom/v1/createMR1Tribes.js";

/**
 * Enum representing the different wild monster tribes.
 * @enum {string}
 */
export enum Tribe {
  LEGIONNAIRE = "Legionnaire",
  KOZU = "Kozu",
  ABUNAKKI = "Abunakki",
  DREADNAUT = "Dreadnaut",
}

/**
 * Enum representing the categories for MR1 tribe scaling.
 * @enum {string}
 */
export enum TribeScale {
  NEW = "NEW",
  TH3 = "TH3",
  TH4 = "TH4",
  TH5 = "TH5",
  HIGH = "HIGH",
}

/**
 * Enum representing the categories for Inferno tribe scaling.
 * @enum {string}
 */
export enum InfernoTribeScale {
  LOW = "low",
  MID = "intermediate",
  HIGH = "high",
}

/**
 * Array of all wild monster tribe types.
 * @type {Tribe[]}
 */
export const Tribes: Tribe[] = [
  Tribe.LEGIONNAIRE,
  Tribe.KOZU,
  Tribe.ABUNAKKI,
  Tribe.DREADNAUT,
];

/**
 * Level scaling config for Inferno tribes
 * @type {Record}
 */
export const MR1_TRIBES: MR1TribeScaleConfig = {
  [TribeScale.NEW]: { maxLevel: 2 },
  [TribeScale.TH3]: { maxLevel: 3 },
  [TribeScale.TH4]: { maxLevel: 4 },
  [TribeScale.TH5]: { maxLevel: 5 },
  [TribeScale.HIGH]: { maxLevel: Infinity }
};

export const INFERNO_TRIBES: TribeScaleConfig = {
  [InfernoTribeScale.LOW]: {
    minTribeId: 214,
    maxLevel: 10,
  },
  [InfernoTribeScale.MID]: {
    minTribeId: 221,
    maxLevel: 20,
  },
  [InfernoTribeScale.HIGH]: {
    minTribeId: 228,
    maxLevel: 56,
  },
};
