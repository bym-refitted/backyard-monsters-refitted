/**
 * Empire points are the sum of a base's accumulated points and its base value.
 *
 * @param {string} basePoints - The base points.
 * @param {string} baseValue - The base value.
 * @returns {number} The combined empire points.
 */
export const calculateEmpirePoints = (basePoints: string, baseValue: string): number => {
  return Number(basePoints) + Number(baseValue);
};
