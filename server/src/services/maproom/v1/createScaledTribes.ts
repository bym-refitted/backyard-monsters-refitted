import { TribeScale } from "../../../enums/Tribes";

export interface TribeDetails {
  minTribeId: number;
  maxLevel: number;
}

export type TribeScaleConfig = Record<TribeScale, TribeDetails>;

/**
 * Returns an array of scaled tribes based on the player's level.
 *
 * Tribes are selected based on the following scaling configuration:
 * - Levels: 1-10 (LOW)
 * - Levels: 11-20 (MID)
 * - Levels: 21+ (HIGH)
 *
 * Example: if the player is level 5, it will select tribes within the LOW range.
 * which consists of tribe IDs at range 214-220 retrieved from
 * `molochTribes.ts`
 *
 * Notes: The client only ever displays 7 tribes at a time, and has a filter
 * to only show tribes within a range of 10 levels.
 *
 * @param {number} level - the player's current level
 * @param {TribeScaleConfig} tribes - scaling configuration for tribes
 * @returns
 */
export const createScaledTribes = (level: number, tribes: TribeScaleConfig) => {
  const playerLevel = Math.max(1, level);
  const levelPattern = [-2, -1, 0, 0, 0, 1, 3];

  let scale: TribeScale;

  if (playerLevel <= tribes[TribeScale.LOW].maxLevel) {
    scale = TribeScale.LOW;
  } else if (playerLevel <= tribes[TribeScale.MID].maxLevel) {
    scale = TribeScale.MID;
  } else {
    scale = TribeScale.HIGH;
  }

  const { minTribeId } = tribes[scale];

  const tribeIds = Array.from({ length: 7 }, (_, i) => minTribeId + i);

  return tribeIds.map((tribeId, i) => {
    const patternIndex = i % levelPattern.length;
    const tribeLevel = Math.max(1, playerLevel + levelPattern[patternIndex]);

    return [tribeId, tribeLevel, 0];
  });
};
