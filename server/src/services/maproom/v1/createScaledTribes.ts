import { TribeScale } from "../../../enums/Tribes";
import { loadFailureErr } from "../../../errors/errors";
import { InfernoMaproom } from "../../../models/infernomaproom.model";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime";

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
 * `molochTribes.ts`.
 * 
 * Tribes are respawned if they have been destroyed for more than 2 hours,
 * by resetting their values in both the maproom table and wmstatus field
 * in the save table.
 *
 * Notes: The client only ever displays 7 tribes at a time, and has a filter
 * to only show tribes within a range of 10 levels.
 *
 * @param {number} level - the player's current level
 * @param {TribeScaleConfig} tribes - scaling configuration for tribes
 * @returns
 */
export const createScaledTribes = async (save: Save, tribes: TribeScaleConfig) => {
  const { userid, wmstatus, level } = save;
  const playerLevel = Math.max(1, level);
  const levelPattern = [-2, -1, 0, 0, 0, 1, 3];

  const twoHours = 2 * 60 * 60;
  const currentTime = getCurrentDateTime();

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

  const maproom = await ORMContext.em.findOne(InfernoMaproom, { userid });
  if (!maproom) throw loadFailureErr();

  const tribeIdSet = new Set(tribeIds);
  let persist = false;

  for (const tribe of maproom.tribedata) {
    //  Only tribes relevant to the current player level are processed
    if (!tribeIdSet.has(Number(tribe.baseid))) continue;

    const canRespawn = tribe.destroyedAt && (currentTime - tribe.destroyedAt > twoHours);

    if (tribe.destroyed && canRespawn) {
      const status = wmstatus.findIndex(
        (status) => status[0] === Number(tribe.baseid)
      );

      if (status !== -1) wmstatus[status][2] = 0;

      // Reset tribe data
      tribe.destroyed = 0;
      tribe.destroyedAt = null;
      tribe.tribeHealthData = {};
      persist = true;
    }
  }

  if (persist) await ORMContext.em.persistAndFlush(maproom);

  return tribeIds.map((tribeId, i) => {
    const patternIndex = i % levelPattern.length;
    const tribeLevel = Math.max(1, playerLevel + levelPattern[patternIndex]);

    const tribeStatus = wmstatus.find((status) => status[0] === tribeId);
    const isDestroyed = tribeStatus ? tribeStatus[2] || 0 : 0;

    return [tribeId, tribeLevel, isDestroyed];
  });
};
