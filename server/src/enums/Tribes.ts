import { worldIdToNumber } from "../utils/generateID";

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
 * Array of all wild monster tribes.
 * @type {Tribe[]}
 */
export const Tribes: Tribe[] = [
  Tribe.LEGIONNAIRE,
  Tribe.KOZU,
  Tribe.ABUNAKKI,
  Tribe.DREADNAUT,
];

export const tribeMinimumLevels = {
  [Tribe.LEGIONNAIRE]: 25,
  [Tribe.KOZU]: 29,
  [Tribe.ABUNAKKI]: 25,
  [Tribe.DREADNAUT]: 25,
};

// We take the world Id, cell Id and tribe
// The tribe is used to crate a limit
// The other values are used for pseudo-randomness without full perlin noise
export const getTribeLevel = (
  cellX: number,
  cellY: number,
  worldId: string,
  tribe: Tribe
) => {
  const worldIdVal = worldIdToNumber(worldId);
  const cellHashNumber = cellX + cellY + worldIdVal;
  const lowerLimit = tribeMinimumLevels[tribe];
  const higherLimit = 45;
  const differnce = higherLimit - lowerLimit;
  return (cellHashNumber % differnce) + lowerLimit;
};
