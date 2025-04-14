import { Tribe } from "../../../enums/Tribes";

/**
 * Object mapping each tribe to its minimum level.
 * @type {Object.<Tribe, number>}
 */
export const minimumTribeLevels = {
  [Tribe.LEGIONNAIRE]: 25,
  [Tribe.KOZU]: 29,
  [Tribe.ABUNAKKI]: 25,
  [Tribe.DREADNAUT]: 25,
};

/**
 * Calculates the level for a wild monster cell.
 *
 * We use the tribe to create a limit.
 * The other values are used for pseudo-randomness without perlin noise usage.
 *
 * @param {number} cellX - The X coordinate of the cell.
 * @param {number} cellY - The Y coordinate of the cell.
 * @param {string} worldId - The ID of the world.
 * @param {Tribe} tribe - The tribe for which the level is being calculated.
 * @returns {number} The calculated level for the cell and tribe.
 */
export const calculateTribeLevel = (
  cellX: number,
  cellY: number,
  tribe: Tribe
) => {
  const cellHashNumber = cellX + cellY;
  const lowerLimit = minimumTribeLevels[tribe];
  const higherLimit = 45;
  const differnce = higherLimit - lowerLimit;

  return (cellHashNumber % differnce) + lowerLimit;
};
