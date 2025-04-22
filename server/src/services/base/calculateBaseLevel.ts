import { experiencePoints } from "../../data/experiencePoints";

/**
 * Calculates the base level based on the given base points and base value.
 *
 * @param {number} basePoints - The base points.
 * @param {number} baseValue - The base value.
 * @returns {number} The calculated base level.
 */
export const calculateBaseLevel = (basePoints: string, baseValue: string) => {
  const points = Number(basePoints) + Number(baseValue);
  let baseLevel = 1;

  for (let i = 0; i < experiencePoints.length; i++) {
    if (points >= experiencePoints[i]) baseLevel = i + 1;
    else break;
  }
  return baseLevel;
};
