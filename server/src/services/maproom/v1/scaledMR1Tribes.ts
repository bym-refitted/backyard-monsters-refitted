import type { TypeOf } from "zod";
import { SaveKeys } from "../../../enums/SaveKeys.js";
import { saveFailureErr } from "../../../errors/errors.js";
import { Maproom } from "../../../models/maproom.model.js";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { BaseSaveSchema } from "../../../schemas/BaseSaveSchema.js";
import { attackLootHandler } from "../../../controllers/base/save/handlers/attackLootHandler.js";
import { MR1_TRIBES_MAP } from "../../../game-data/tribes/v1/index.js";

type BaseSaveData = TypeOf<typeof BaseSaveSchema>;

/**
 * Persists MR1 tribe attack state (building health, monsters, destroyed) to
 * the player's Maproom.tribedata record
 *
 * @param {User} user - The attacking user
 * @param {BaseSaveData} saveData - Parsed save payload from the client
 * @returns {Promise<Save>} Synthetic Save reflecting updated tribe state
 */
export const scaledMR1Tribes = async (user: User, saveData: BaseSaveData) => {
  const userSave = user.save!;

  const maproom = await postgres.em.findOne(Maproom, { userid: user.userid });

  if (!maproom) throw new Error(`MapRoom not found for userid: ${user.username}`);

  const existingTribe = maproom.tribedata.find((tribe) => tribe.baseid === saveData.baseid);

  if (!existingTribe) throw saveFailureErr();

  existingTribe.tribeHealthData = saveData.buildinghealthdata ?? existingTribe.tribeHealthData;
  existingTribe.monsters = saveData.monsters;
  existingTribe.destroyed = saveData.destroyed;
  existingTribe.destroyedAt = saveData.destroyed ? getCurrentDateTime() : undefined;

  userSave.wmstatus.forEach((tribe) => {
    if (tribe[0] === Number(saveData.baseid)) tribe[2] = saveData.destroyed ?? 0;
  });

  const tribeData = MR1_TRIBES_MAP.get(saveData.baseid);

  if (!tribeData) throw new Error(`No MR1 tribe data found for baseid: ${saveData.baseid}`);

  const tribeSave = Object.assign(new Save(), {
    ...tribeData,
    baseid: saveData.baseid,
    buildinghealthdata: existingTribe.tribeHealthData,
    monsters: existingTribe.monsters ?? tribeData.monsters,
  });

  for (const key of Object.keys(saveData) as (keyof typeof saveData)[]) {
    const value = saveData[key];

    switch (key) {
      case SaveKeys.ATTACKCREATURES:
        userSave.monsters = value;
        break;

      case SaveKeys.ATTACKERCHAMPION:
        if (saveData.attackerchampion) userSave.champion = saveData.attackerchampion;
        break;

      case SaveKeys.ATTACKLOOT:
        if (value) attackLootHandler(value, userSave);
        break;
    }
  }

  postgres.em.persist(maproom);
  postgres.em.persist(userSave);
  await postgres.em.flush();

  return tribeSave;
};
