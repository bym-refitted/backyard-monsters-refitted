import { TribeScale } from "../../../enums/Tribes.js";
import { legionnaire } from "../../../data/tribes/v1/legionnaire.js";
import { kozu } from "../../../data/tribes/v1/kozu.js";
import { abunaki } from "../../../data/tribes/v1/abunaki.js";
import { dreadnaught } from "../../../data/tribes/v1/dreadnaught.js";
import { tutorial } from "../../../data/tribes/v1/tutorial.js";
import { Maproom } from "../../../models/maproom.model.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";

export interface MR1TribeScaleConfig {
  [TribeScale.NEW]: { maxLevel: number };     // Town Hall 1–2
  [TribeScale.TH3]: { maxLevel: number };     // Town Hall 3
  [TribeScale.TH4]: { maxLevel: number };     // Town Hall 4
  [TribeScale.TH5]: { maxLevel: number };     // Town Hall 5
  [TribeScale.HIGH]: { maxLevel: number };    // Town Hall 6 >
}

const mr1TribeData = [legionnaire, kozu, abunaki, dreadnaught];

/**
 * Returns an array of scaled MR1 tribes based on the player's Town Hall level.
 *
 * Each scale maps to a different baseid per tribe type so the client loads
 * the appropriate difficulty variant. The wmstatus level is set dynamically
 * relative to the player's level so tribes always pass the client's
 * _baseLevel - 10 display filter.
 *
 * Destroyed tribes respawn after 10 minutes.
 *
 * @param {Save} save - The player's main save
 * @param {MR1TribeScaleConfig} tribes - Town Hall level thresholds per scale (max TH level is 10)
 * @returns {Promise<number[][]>} wmstatus array of [baseid, level, destroyed] tuples
 */
export const createMR1Tribes = async (save: Save, tribes: MR1TribeScaleConfig) => {
  const { userid, wmstatus, level } = save;
  const playerLevel = Math.max(1, level);
  const levelPattern = [-1, 0, 1, 2];

  const townHall = extractTownHall(save.buildingdata ?? {});
  const thLevel = townHall?.l ?? 1;

  const tenMinutes = 10 * 60;
  const currentTime = getCurrentDateTime();

  let scale: TribeScale;
  let persist = false;

  if (thLevel <= tribes[TribeScale.NEW].maxLevel) {
    scale = TribeScale.NEW;
  } else if (thLevel <= tribes[TribeScale.TH3].maxLevel) {
    scale = TribeScale.TH3;
  } else if (thLevel <= tribes[TribeScale.TH4].maxLevel) {
    scale = TribeScale.TH4;
  } else if (thLevel <= tribes[TribeScale.TH5].maxLevel) {
    scale = TribeScale.TH5;
  } else {
    scale = TribeScale.HIGH;
  }

  const inTutorial = save.tutorialstage < 205;

  const scaledTribes = mr1TribeData.map((tribe, i) => i === 0 && inTutorial ? tutorial : tribe[scale]);
  const scaledBaseIds = new Set(scaledTribes.map((tribe) => Number(tribe.baseid)));

  let maproom = await postgres.em.findOne(Maproom, { userid });

  if (!maproom) {
    const user = await postgres.em.findOne(User, { userid });

    if (!user) throw new Error(`User not found for userid: ${userid}`);

    maproom = await Maproom.setupMapRoomData(postgres.em, user);
  }

  // Only store tribedata within the user's current level range
  const currentTribes = maproom.tribedata.filter((tribe) =>
    scaledBaseIds.has(Number(tribe.baseid))
  );

  // Respawn tribes destroyed more than 1 hour ago
  for (const tribe of maproom.tribedata) {
    const canRespawn = tribe.destroyedAt && currentTime - tribe.destroyedAt > tenMinutes;

    if (tribe.destroyed && canRespawn) {
      const status = wmstatus?.findIndex((status) => status[0] === Number(tribe.baseid));

      if (status !== undefined && status !== -1) wmstatus![status][2] = 0;

      tribe.destroyed = 0;
      tribe.destroyedAt = undefined;
      tribe.tribeHealthData = {};
      tribe.monsters = undefined;
      persist = true;
    }
  }

  maproom.tribedata = currentTribes;

  if (persist) {
    postgres.em.persist(maproom);
    await postgres.em.flush();
  }

  return scaledTribes.map((tribe, i) => {
    const tribeLevel = Math.max(1, playerLevel + levelPattern[i]);
    const tribeStatus = wmstatus?.find((s) => s[0] === Number(tribe.baseid));
    const isDestroyed = tribeStatus ? tribeStatus[2] || 0 : 0;
    return [Number(tribe.baseid), tribeLevel, isDestroyed];
  });
};
