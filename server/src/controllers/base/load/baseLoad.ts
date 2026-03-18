import { devConfig } from "../../../config/DevSettings.js";
import { Save } from "../../../models/save.model.js";
import { postgres } from "../../../server.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { storeItems } from "../../../data/store/storeItems.js";
import { User } from "../../../models/user.model.js";
import { FilterFrontendKeys } from "../../../utils/FrontendKey.js";
import { getFlags } from "../../../data/flags.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { BaseMode, BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { WORLD_SIZE } from "../../../config/MapRoom2Config.js";
import { RESOURCE_PRODUCTION_RATES, RESOURCE_CAPACITIES, DEFENDER_DAMAGE_REDUCTION, STRONGHOLD_BONUSES } from "../../../config/MapRoom3Config.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { getDefenderCoords, isDefensiveStructure } from "../../../services/maproom/v3/getDefenderCoords.js";
import { Status } from "../../../enums/StatusCodes.js";
import { baseModeView } from "./modes/baseModeView.js";
import { baseModeBuild } from "./modes/baseModeBuild.js";
import { logger } from "../../../utils/logger.js";
import { baseModeAttack } from "./modes/baseModeAttack.js";
import { mapUserSaveData } from "../mapUserSaveData.js";
import { infernoModeDescent } from "./modes/infernoModeDescent.js";
import { infernoModeView } from "./modes/infernoModeView.js";
import { infernoModeAttack } from "./modes/infernoModeAttack.js";
import { infernoModeBuild } from "./modes/infernoModeBuild.js";
import { validateAttack } from "../../../services/maproom/validateAttack.js";
import { BaseLoadSchema } from "../../../zod/BaseLoadSchema.js";
import { discordAgeErr } from "../../../errors/errors.js";
import { EnumBaseRelationship } from "../../../enums/EnumBaseRelationship.js";
import { canAttack } from "../../../services/base/canAttack.js";

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

  try {
    const worldid = user.save?.worldid;
    const { baseid, type, mapversion, attackData, attackcost } = BaseLoadSchema.parse(ctx.request.body);

    let baseSave: Save = null;

    switch (type) {
      case BaseMode.BUILD:
        baseSave = await baseModeBuild(user, baseid);
        break;

      case BaseMode.VIEW:
      case BaseMode.IVIEW:
        baseSave = await baseModeView(baseid, mapversion, worldid);
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
        await validateAttack(user, attackData, mapversion);
        baseSave = await infernoModeAttack(user, baseid);
        break;
        
      default:
        throw new Error(`Base type not handled, type: ${type}.`);
    }

    const filteredSave = FilterFrontendKeys(baseSave);
    const isTutorialEnabled = devConfig.skipTutorial ? 205 : filteredSave.tutorialstage;

    const flags = getFlags();
    flags.discordOldEnough = ctx.meetsDiscordAgeCheck;

    const isOwner = baseSave.type !== BaseType.INFERNO && user.userid === filteredSave.userid;

    let totalResourceRate = 0;
    let totalResourceCapacity = 0;
    let totalStrongholdBonus = 0;
    let defenderReduction = 0;

    // Sum production rate, storage capacity, and stronghold bonuses from player-owned MR3 outposts.
    if (mapversion === MapRoomVersion.V3 && isOwner) {
      const [resourceOutposts, strongholdOutposts] = await Promise.all([
        postgres.em.find(Save, { saveuserid: user.userid, type: BaseType.OUTPOST, wmid: EnumYardType.RESOURCE }),
        postgres.em.find(Save, { saveuserid: user.userid, type: BaseType.OUTPOST, wmid: EnumYardType.STRONGHOLD }),
      ]);

      for (const { level } of resourceOutposts) {
        totalResourceRate += RESOURCE_PRODUCTION_RATES[level];
        totalResourceCapacity += RESOURCE_CAPACITIES[level];
      }

      for (const { level } of strongholdOutposts) {
        totalStrongholdBonus += STRONGHOLD_BONUSES[level];
      }
    }

    // Set damage reduction buff for attacking bases with defenders
    if (mapversion === MapRoomVersion.V3 && !isOwner && type === BaseMode.ATTACK) {
      const attackedCell: WorldMapCell = baseSave.cell;

      if (attackedCell?.uid && isDefensiveStructure(attackedCell.base_type)) {
        const defenderCoords = getDefenderCoords(attackedCell.x, attackedCell.y, attackedCell.base_type);

        const defenderCells = await postgres.em.find(WorldMapCell, {
          $and: [
            { $or: defenderCoords.map(([x, y]) => ({ x, y })) },
            { base_type: EnumYardType.FORTIFICATION },
            { uid: attackedCell.uid },
            { map_version: MapRoomVersion.V3 },
            { world_id: worldid },
          ],
        });

        defenderReduction = DEFENDER_DAMAGE_REDUCTION[defenderCells.length];
      }
    }

    const attackAllowed = canAttack(user.save, baseSave, mapversion);

    ctx.status = Status.OK;
    ctx.body = {
      ...filteredSave,
      relationship: isOwner ? EnumBaseRelationship.SELF : EnumBaseRelationship.ENEMY,
      canattack: attackAllowed,
      flags,
      worldsize: WORLD_SIZE,
      error: 0,
      id: filteredSave.basesaveid,
      champion: JSON.stringify(filteredSave.champion),
      storeitems: { ...storeItems },
      tutorialstage: isTutorialEnabled,
      currenttime: getCurrentDateTime(),
      pic_square: `${process.env.AVATAR_URL}?seed=${filteredSave.name}&size=${50}`,
      ...(isOwner && mapUserSaveData(user)),
      ...(isOwner && mapversion === MapRoomVersion.V3 && {
        player: {
          buffs: {
            2: totalResourceRate,
            10: totalResourceCapacity,
            ...(totalStrongholdBonus > 0 && { 5: totalStrongholdBonus, 6: totalStrongholdBonus }),
          },
        },
      }),
      ...(defenderReduction > 0 && {
        player: { buffs: { 1: defenderReduction } },
      }),
    };
  } catch (err) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "The server failed to load this base." };
    logger.error(`Failed to load base`, err);
  }
};
