import { BaseMode, BaseType } from "../../../../enums/Base.js";
import { MapRoomCell, MapRoomVersion } from "../../../../enums/MapRoom.js";
import { World } from "../../../../models/world.model.js";
import { WorldMapCell } from "../../../../models/worldmapcell.model.js";
import { postgres } from "../../../../server.js";
import { damageProtection } from "../../../../services/maproom/v2/damageProtection.js";
import { Save } from "../../../../models/save.model.js";
import { User } from "../../../../models/user.model.js";
import { tribeSaveHandler } from "../../../../services/maproom/tribeSaveHandler.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import { validateRange } from "../../../../services/maproom/v2/validateRange.js";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../../services/maproom/v2/generateMap.js";
import { getGeneratedCells, cellKey } from "../../../../services/maproom/v3/generateCells.js";
import { createAttackLog } from "../../../../services/base/createAttackLog.js";
import { updateResources, Operation } from "../../../../services/base/updateResources.js";
import { isAttackActive } from "../../../../services/base/isAttackActive.js";
import { baseUnderAttackErr, userOnlineErr } from "../../../../errors/errors.js";
import { redis } from "../../../../server.js";

import { MR1_TRIBE_IDS } from "../../../../data/tribes/v1/index.js";
import { registerAttacker } from "../../../../services/maproom/v1/registerAttacker.js";

export interface AttackDetails {
  fbid?: string;
  name: string;
  pic_square?: string;
  friend: number;
  count: number;
  starttime: number;
  seen: boolean;
}

interface BaseModeAttack {
  user: User;
  baseid: string;
  mapversion?: MapRoomVersion;
  attackCost?: { resources?: number[]; shiny?: number };
}

/**
 * Processes an attack from a user against a specific base
 *
 * @param {BaseModeAttack} options - Attack options
 * @returns Result of range validation check
 */
export const baseModeAttack = async ({ user, baseid, mapversion, attackCost }: BaseModeAttack) => {
  const userSave = user.save!;
  let save: Save | null = null;

  if (mapversion === MapRoomVersion.V1 && MR1_TRIBE_IDS.has(baseid)) {
    save = await tribeSaveHandler(baseid, mapversion, userSave.worldid, user);
  } else {
    save = await postgres.em.findOne(Save, { baseid });
    if (!save) save = await tribeSaveHandler(baseid, mapversion, userSave.worldid, user);
  }

  if (!save) throw new Error(`Save not found for baseid: ${baseid}`);

  if (save.type !== BaseType.TRIBE) {
    const lastSeen = await redis.get(`last-seen:${BaseType.MAIN}:${save.userid}`);
    
    if (lastSeen && parseInt(lastSeen) >= getCurrentDateTime() - 60) throw userOnlineErr();

    if (isAttackActive(save)) throw baseUnderAttackErr();
  }

  if (save.attacks.length > 3) save.attacks = save.attacks.slice(-2);

  // Track the details of the attack
  const attackDetails: AttackDetails = {
    fbid: "",
    name: user.username,
    pic_square: user.pic_square ?? undefined,
    friend: 0,
    count: 1,
    starttime: getCurrentDateTime(),
    seen: false,
  };

  if (save.type != BaseType.TRIBE) save.attacks.push(attackDetails);

  await damageProtection(userSave, BaseMode.ATTACK);

  save.attackid = Math.floor(Math.random() * 99999) + 1;

  if (mapversion !== MapRoomVersion.V1) {
    let cell = await postgres.em.findOne(WorldMapCell, { baseid });

    if (!cell) {
      const cellX = parseInt(baseid.slice(-6, -3));
      const cellY = parseInt(baseid.slice(-3));

      const world = await postgres.em.findOne(World, { uuid: userSave.worldid });

      if (!world) throw new Error("No world found.");

      if (mapversion === MapRoomVersion.V3) {
        const genCell = getGeneratedCells().get(cellKey(cellX, cellY));

        cell = new WorldMapCell(world, cellX, cellY, genCell?.altitude ?? 0);
        cell.uid = save.saveuserid;
        cell.base_type = genCell?.type ?? save.wmid;
        cell.map_version = MapRoomVersion.V3;
        cell.baseid = baseid;
      } else {
        const noise = generateNoise(world.uuid);
        const terrainHeight = getTerrainHeight(noise, cellX, cellY);

        cell = new WorldMapCell(world, cellX, cellY, terrainHeight);
        cell.uid = save.saveuserid;
        cell.base_type = MapRoomCell.WM;
        cell.map_version = MapRoomVersion.V2;
        cell.baseid = baseid;
      }
    }

    save.cell = cell;
    postgres.em.persist(cell);
  }

  // Handle attack cost for MR3 attack range
  if (mapversion === MapRoomVersion.V3 && attackCost) {
    if (attackCost.resources) {
      const [r1, r2, r3] = attackCost.resources;
      updateResources({ r1, r2, r3 }, userSave.resources!, Operation.SUBTRACT);
    } else if (attackCost.shiny) {
      userSave.credits = Math.max(0, userSave.credits - attackCost.shiny);
    }
  }

  const isMR1Tribe = mapversion === MapRoomVersion.V1 && save.type === BaseType.TRIBE;
  
  if (!isMR1Tribe) postgres.em.persist(save);

  postgres.em.persist(userSave);
  await postgres.em.flush();

  // Create an attack log and update neighbour attack counters
  if (save.type !== BaseType.TRIBE) {
    const defender = await postgres.em.findOne(User, {
      userid: save.saveuserid,
    });

    if (!defender) throw new Error("Defender user not found.");

    if (mapversion === MapRoomVersion.V1) await registerAttacker(user, defender);
    await createAttackLog(user, defender, save)
  }

  return await validateRange(user, save, mapversion, { baseid });
};
