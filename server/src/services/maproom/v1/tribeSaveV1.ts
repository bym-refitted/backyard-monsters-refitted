import { Save } from "../../../models/save.model.js";
import { Maproom } from "../../../models/maproom.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { MR1_TRIBES_MAP } from "../../../game-data/tribes/v1/index.js";
import type { TribeData } from "../../../types/TribeData.js";

/**
 * Generates a synthetic Save for an MR1 wild monster tribe base.
 *
 * Looks up the tribe template by baseid and tracks per-user building health
 * state in the player's Maproom record so damage persists across sessions.
 *
 * @param {string} baseid - The tribe base ID (matches TRIBES.as L/K/A/D_IDS)
 * @param {User} user - The requesting user
 * @returns {Promise<Save>} A synthetic Save representing the tribe base
 */
export const tribeSaveV1 = async (baseid: string, user: User): Promise<Save> => {
  let maproom = await postgres.em.findOne(Maproom, { userid: user.userid });

  if (!maproom) throw new Error(`MapRoom not found for userid: ${user.username}`);

  let existingTribe = maproom.tribedata.find((tribe) => tribe.baseid === baseid);

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };
    maproom.tribedata.push(newTribe);

    postgres.em.persist(maproom);
    await postgres.em.flush();
    
    existingTribe = newTribe;
  }

  const tribeData = MR1_TRIBES_MAP.get(baseid);

  if (!tribeData) throw new Error(`No MR1 tribe data found for baseid: ${baseid}`);

  return Object.assign(new Save(), {
    ...tribeData,
    baseid,
    buildinghealthdata: existingTribe.tribeHealthData || {},
    monsters: existingTribe.monsters ?? tribeData.monsters,
  });
};
