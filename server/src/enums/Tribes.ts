import { TribeScaleConfig } from "../services/maproom/v1/createScaledTribes.js";

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
 * Enum representing the categories for MR1/Inferno tribe scaling.
 * @enum {string}
 */
export enum TribeScale {
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
export const INFERNO_TRIBES: TribeScaleConfig = {
  [TribeScale.LOW]: {
    minTribeId: 214,
    maxLevel: 10,
  },
  [TribeScale.MID]: {
    minTribeId: 221,
    maxLevel: 20,
  },
  [TribeScale.HIGH]: {
    minTribeId: 228,
    maxLevel: 56,
  },
};
