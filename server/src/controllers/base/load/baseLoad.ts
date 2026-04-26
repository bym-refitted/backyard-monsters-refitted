import { devConfig } from "../../../config/GameConfig.js";
import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { storeItems } from "../../../game-data/store/storeItems.js";
import { User } from "../../../models/user.model.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import { getFlags } from "../../../game-data/flags.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { BaseMode, BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { WORLD_SIZE } from "../../../config/MapRoom2Config.js";
import { RESOURCE_PRODUCTION_RATES, RESOURCE_CAPACITIES, DEFENDER_DAMAGE_REDUCTION, STRONGHOLD_BONUSES, STRUCTURE_RANGE } from "../../../config/MapRoom3Config.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { getDefenderCoords, isDefensiveStructure } from "../../../services/maproom/v3/getDefenderCoords.js";
import { getHexDistance } from "../../../services/maproom/v3/getHexNeighborOffsets.js";
import { Status } from "../../../enums/StatusCodes.js";
import { baseModeView } from "./modes/baseModeView.js";
import { baseModeBuild } from "./modes/baseModeBuild.js";
import { baseModeAttack } from "./modes/baseModeAttack.js";
import { mapUserSaveData } from "../mapUserSaveData.js";
import { infernoModeDescent } from "./modes/infernoModeDescent.js";
import { infernoModeView } from "./modes/infernoModeView.js";
import { infernoModeAttack } from "./modes/infernoModeAttack.js";
import { infernoModeBuild } from "./modes/infernoModeBuild.js";
import { validateAttack } from "../../../services/maproom/validateAttack.js";
import { BaseLoadSchema } from "../../../schemas/BaseLoadSchema.js";
import { discordAgeErr } from "../../../errors/errors.js";
import { EnumBaseRelationship } from "../../../enums/EnumBaseRelationship.js";
import { canAttack } from "../../../services/base/canAttack.js";
import { createMR1Tribes } from "../../../services/maproom/v1/createMR1Tribes.js";
import { MR1_TRIBES } from "../../../enums/Tribes.js";
import { tutorial } from "../../../game-data/tribes/v1/index.js";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel.js";
import { extractTownHall } from "../../../utils/extractTownHall.js";

/**
 * Controller responsible for loading base modes based on the user's request.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} A promise that resolves when the base load process is complete.
 * @throws Will throw an error if the base load process fails.
 */
export const baseLoad: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save", "infernosave"]);

  const { baseid, type, mapversion, attackData, attackcost } = BaseLoadSchema.parse(ctx.request.body);

  let baseSave: Save | null = null;

  switch (type) {
    case BaseMode.BUILD:
      baseSave = await baseModeBuild(user, baseid);
      break;

    case BaseMode.VIEW:
    case BaseMode.IVIEW:
      baseSave = await baseModeView(baseid, mapversion, user.save!.worldid, user);
      break;

    case BaseMode.ATTACK:
      if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

      await validateAttack(user, attackData, mapversion);
      baseSave = await baseModeAttack({ user, baseid, mapversion, attackCost: attackcost });
      break;

    case BaseMode.IDESCENT:
      baseSave = await infernoModeDescent(user);
      break;

    case BaseMode.IBUILD:
      baseSave = await infernoModeBuild(user);
      break;

    case BaseMode.IWMVIEW:
      baseSave = await infernoModeView(user, baseid);
      break;

    case BaseMode.IATTACK:
      if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

      await validateAttack(user, attackData, mapversion);
      baseSave = await infernoModeAttack(user, baseid);
      break;

    case BaseMode.IWMATTACK:
      if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();
      
      await validateAttack(user, attackData, mapversion);
      baseSave = await infernoModeAttack(user, baseid);
      break;

    case BaseMode.WMVIEW:
      baseSave = await baseModeView(baseid, mapversion, user.save!.worldid, user);
      break;

    case BaseMode.WMATTACK:
      if (!ctx.meetsDiscordAgeCheck && baseid !== tutorial.baseid) throw discordAgeErr();
      
      await validateAttack(user, attackData, mapversion);
      baseSave = await baseModeAttack({ user, baseid, mapversion, attackCost: attackcost });
      break;

    default:
      throw new Error(`Base type not handled, type: ${type}.`);
  }

  if (!baseSave) throw new Error("Base save not found.");

  const userSave = user.save!;

  if (type === BaseMode.BUILD && mapversion === MapRoomVersion.V1) {
    userSave.level = calculateBaseLevel(userSave.points, userSave.basevalue);
    const mr1Tribes = await createMR1Tribes(userSave, MR1_TRIBES);
    const wmstatus = new Map(userSave.wmstatus.map((status) => [status[0], status]));

    mr1Tribes.forEach((tribe) => wmstatus.set(tribe[0], tribe));
    userSave.wmstatus = [...wmstatus.values()];
    
    postgres.em.persist(userSave);
    await postgres.em.flush();
  }

  const filteredSave = FilterFrontendKeys(baseSave);
  const isTutorialEnabled = devConfig.skipTutorial ? 205 : filteredSave.tutorialstage;

  const flags = getFlags();
  flags.discordOldEnough = Number(ctx.meetsDiscordAgeCheck);

  const townHall = extractTownHall(userSave.buildingdata || {});

  flags.maproom2 = userSave.mr2upgraded || (townHall && townHall.l >= 6) ? 1 : 0;
  flags.mr2upgraded = userSave.mr2upgraded ? 1 : 0;

  const isOwner = baseSave.type !== BaseType.INFERNO && user.userid === filteredSave.userid;

  let totalResourceRate = 0;
  let totalResourceCapacity = 0;
  let totalStrongholdBonus = 0;
  let totalDefenderStrongholdBonus = 0;
  let defenderReduction = 0;

  if (mapversion === MapRoomVersion.V3) {
    // Sum production rate and storage capacity from all player-owned MR3 resource outposts.
    if (isOwner) {
      const resourceOutposts = await postgres.em.find(Save, {
        saveuserid: user.userid,
        type: BaseType.OUTPOST,
        wmid: EnumYardType.RESOURCE,
      });

      for (const { level } of resourceOutposts) {
        totalResourceRate += RESOURCE_PRODUCTION_RATES[level];
        totalResourceCapacity += RESOURCE_CAPACITIES[level];
      }

      // Auto-bank calculates and applies resources accumulated since the player's last session.
      if (type === BaseMode.BUILD && totalResourceRate > 0) {
        const now = getCurrentDateTime();
        const lastAccumulated = userSave.buildingresources?.t;

        if (lastAccumulated) {
          const elapsed = now - lastAccumulated;
          const accumulated = Math.floor(totalResourceRate * elapsed);

          if (accumulated > 0 && userSave.resources) {
            for (const resource of ["r1", "r2", "r3", "r4"])
              userSave.resources[resource] += accumulated;
          }
        }

        userSave.buildingresources!.t = now;
        postgres.em.persist(userSave);
        await postgres.em.flush();
      }
    }

    // Strongholds boost monster damage (attacker) and tower damage (defender),
    // but only if the target cell falls within their attack range.
    if (type === BaseMode.ATTACK && baseSave.cell) {
      const targetCell: WorldMapCell = baseSave.cell;

      const [attackerStrongholds, defenderStrongholds] = await Promise.all([
        postgres.em.find(
          Save,
          {
            saveuserid: user.userid,
            type: BaseType.OUTPOST,
            wmid: EnumYardType.STRONGHOLD,
          },
          { populate: ["cell"] },
        ),
          
        postgres.em.find(
          Save,
          {
            saveuserid: baseSave.saveuserid,
            type: BaseType.OUTPOST,
            wmid: EnumYardType.STRONGHOLD,
          },
          { populate: ["cell"] },
        ),
      ]);

      const strongholdBonus = (strongholds: Save[]) => {
        let bonus = 0;

        for (const { level, cell } of strongholds) {
          const distance = cell && getHexDistance(cell.x, cell.y, targetCell.x, targetCell.y);
            
          if (distance && distance <= STRUCTURE_RANGE[EnumYardType.STRONGHOLD][level])
            bonus += STRONGHOLD_BONUSES[level];
        }
        return bonus;
      };

      totalStrongholdBonus = strongholdBonus(attackerStrongholds);
      totalDefenderStrongholdBonus = strongholdBonus(defenderStrongholds);
    }
  }

  // Set damage reduction buff for attacking bases with defenders
  if (mapversion === MapRoomVersion.V3 && !isOwner && type === BaseMode.ATTACK) {
    const attackedCell = baseSave.cell;

    if (attackedCell?.uid && isDefensiveStructure(attackedCell.base_type)) {
      const defenderCoords = getDefenderCoords(attackedCell.x, attackedCell.y, attackedCell.base_type);

      const defenderCells = await postgres.em.find(WorldMapCell, {
        $and: [
          { $or: defenderCoords.map(([x, y]) => ({ x, y })) },
          { base_type: EnumYardType.FORTIFICATION },
          { uid: attackedCell.uid },
          { map_version: MapRoomVersion.V3 },
          { world: user.save!.worldid },
        ],
      });

      defenderReduction = DEFENDER_DAMAGE_REDUCTION[defenderCells.length];
    }
  }

  const attackAllowed = canAttack(userSave, baseSave, mapversion);

  let avatarUser;

  if (isOwner) {
    avatarUser = user;
  } else {
    avatarUser = await postgres.em.findOne(
      User,
      { userid: baseSave.userid },
      { fields: ["pic_square"] }
    );
  }

  const avatar = avatarUser?.pic_square;

  const response: Record<string, unknown> = {
    ...filteredSave,
    relationship: isOwner ? EnumBaseRelationship.SELF : EnumBaseRelationship.ENEMY,
    canattack: attackAllowed,
    flags,
    worldsize: WORLD_SIZE,
    error: 0,
    id: filteredSave.basesaveid,
    storeitems: storeItems,
    tutorialstage: isTutorialEnabled,
    currenttime: getCurrentDateTime(),
    pic_square: avatar,
    ...(isOwner && mapUserSaveData(user)),
  };

  if (isOwner && mapversion === MapRoomVersion.V3) {
    response.player = { buffs: { 2: totalResourceRate, 10: totalResourceCapacity } };
  }

  if (defenderReduction > 0) {
    response.player = { buffs: { 1: defenderReduction } };
  }

  if (type === BaseMode.ATTACK && mapversion === MapRoomVersion.V3) {
    if (totalStrongholdBonus > 0) response.attackingplayer = { buffs: { 5: totalStrongholdBonus } };
    if (totalDefenderStrongholdBonus > 0) response.defendingplayer = { buffs: { 6: totalDefenderStrongholdBonus } };
  }

  if (type === BaseMode.IDESCENT) {
    response.resources = filteredSave.iresources;
  }

  ctx.status = Status.OK;
  ctx.body = response;
};
