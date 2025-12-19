import { molochTribes } from "../../../../data/tribes/inferno/molochTribes";
import { BaseType } from "../../../../enums/Base";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { postgres } from "../../../../server";
import { createAttackLog } from "../../../../services/base/createAttackLog";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime";
import { AttackDetails } from "./baseModeAttack";
import { addAttackerAsNeighbour } from "../../../../services/maproom/inferno/addAttackerAsNeighbour";
import {
  InfernoMaproom,
  TribeData,
} from "../../../../models/infernomaproom.model";

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


  if (!save) return infernoTribeSave(user, baseid);

  if (save.attacks.length > 3) {
    save.attacks = save.attacks.slice(-2);
  }

  const attackDetails: AttackDetails = {
    fbid: user.save.fbid,
    name: user.username,
    pic_square: user.pic_square,
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
    addAttackerAsNeighbour(user, defender),
    createAttackLog(user, defender, save),
  ]);

  await postgres.em.persistAndFlush(save);
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
  const maproom1 = await postgres.em.findOne(InfernoMaproom, {
    userid: user.userid,
  });

  let existingTribe = maproom1.tribedata.find(
    (tribe) => tribe.baseid === baseid
  );

  if (!existingTribe) {
    const newTribe: TribeData = { baseid, tribeHealthData: {} };

    maproom1.tribedata.push(newTribe);
    await postgres.em.persistAndFlush(maproom1);
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
