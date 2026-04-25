import { molochTribes } from "../../../../data/tribes/inferno/molochTribes.js";
import { BaseMode, BaseType } from "../../../../enums/Base.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { postgres } from "../../../../server.js";
import { createAttackLog } from "../../../../services/base/createAttackLog.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import type { AttackDetails } from "./baseModeAttack.js";
import { registerInfernoAttacker } from "../../../../services/maproom/inferno/registerInfernoAttacker.js";
import {
  InfernoMaproom,
  type TribeData,
} from "../../../../models/infernomaproom.model.js";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection.js";
import { isAttackActive } from "../../../../services/base/isAttackActive.js";
import { baseUnderAttackErr, baseProtectedErr, userOnlineErr } from "../../../../errors/errors.js";
import { redis } from "../../../../server.js";

/**
 * Handles Inferno mode attacks for both real players and AI tribes
 *
 * First attempts to find a real player's Inferno save. If found, processes the attack
 * by tracking attack details, creating attack logs, and updating the save.
 * If no player save is found, falls back to tribe logic.
 *
 * @param {User} user - The attacking user
 * @param {string} baseid - The ID of the base being attacked
 * @returns {Promise<Save>} The save data for the attacked base
 */
export const infernoModeAttack = async (user: User, baseid: string) => {
  const save = await postgres.em.findOne(Save, {
    type: BaseType.INFERNO,
    baseid,
  });

  if (user.infernosave) {
    await damageProtection(user.infernosave, BaseMode.IATTACK);
  }

  if (!save) {
    return infernoTribeSave(user, baseid);
  }

  if (save.protected > getCurrentDateTime()) throw baseProtectedErr();

  const lastSeen = await redis.get(`last-seen:${BaseType.INFERNO}:${save.userid}`);
  
  if (lastSeen && parseInt(lastSeen) >= getCurrentDateTime() - 60) throw userOnlineErr();

  if (isAttackActive(save)) throw baseUnderAttackErr();

  if (save.attacks.length > 3) { 
    save.attacks = save.attacks.slice(-2); 
  }

  const attackDetails: AttackDetails = {
    fbid: "",
    name: user.username,
    pic_square: user.pic_square ?? undefined,
    friend: 0,
    count: 1,
    starttime: getCurrentDateTime(),
    seen: false
  };

  save.attacks.push(attackDetails);
  save.attackid = Math.floor(Math.random() * 99999) + 1;

  const defender = await postgres.em.findOne(User, {
    userid: save.saveuserid,
  });

  if (!defender) throw new Error("Defender user not found.");


  await Promise.all([
    registerInfernoAttacker(user, defender),
    createAttackLog(user, defender, save),
  ]);

  postgres.em.persist(save);
  await postgres.em.flush();
  return save;
};

/**
 * Creates or retrieves a tribe save for Inferno mode attacks
 *
 * Manages tribe data in the user's InfernoMaproom, creating new tribe entries
 * if they don't exist. Retrieves tribe template data from molochTribes and
 * creates a synthetic Save object with the tribe's configuration and any
 * existing building health data.
 *
 * @param {User} user - The attacking user
 * @param {string} baseid - The ID of the tribe base being attacked
 * @returns {Promise<Save>} A synthetic Save object representing the tribe base
 * @throws {Error} When no tribe data is found for the given baseid
 */
const infernoTribeSave = async (user: User, baseid: string): Promise<Save> => {
  const maproomInferno = await postgres.em.findOne(InfernoMaproom, { userid: user.userid });

  if (!maproomInferno) throw new Error(`Inferno maproom not found for user: ${user.username}`);

  let existingTribe = maproomInferno.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };

    maproomInferno.tribedata.push(newTribe);
    postgres.em.persist(maproomInferno);
    await postgres.em.flush();
    existingTribe = newTribe;
  }

  const tribeData = molochTribes.find((tribe) => tribe.baseid === baseid);

  if (!tribeData) throw new Error(`No tribe data found for baseid: ${baseid}`);

  return Object.assign(new Save(), {
    ...tribeData,
    baseid,
    buildinghealthdata: existingTribe.tribeHealthData || {},
    monsters: existingTribe.monsters ?? tribeData.monsters,
  });
};
